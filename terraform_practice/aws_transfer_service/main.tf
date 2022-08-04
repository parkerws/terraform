terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "4.24.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "Nah"
  secret_key = "I think not"
}

resource "aws_vpc" "vpc_main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "tf-vpc-main"
    }
    enable_dns_hostnames = true
  
}

resource "aws_subnet" "subnet_main" {
    vpc_id = "${aws_vpc.vpc_main.id}"
    cidr_block = "10.0.0.0/24"
}


resource "aws_eip" "public_ip" {
  vpc = true
  tags = {
    "Name" = "eip_sftp"
  }
}

resource "aws_internet_gateway" "transfer_gateway" {
    vpc_id = aws_vpc.vpc_main.id

    tags = {
        Name = "transfer_gateway"
    }
}

resource "aws_route_table" "transfer_rt" {
    vpc_id = aws_vpc.vpc_main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.transfer_gateway.id
    }
    tags = {
        Name = "transfer_rt"
    }
}

resource "aws_route_table_association" "test_route_assn" {
    subnet_id = aws_subnet.subnet_main.id
    route_table_id = aws_route_table.transfer_rt.id
}


resource "aws_security_group" "sg1" {
  name        = "allow_tls"
  description = "Allow SFTP"
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
    description      = "internet_inbound"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_sftp_transfer_server"
  }
}

data "aws_s3_bucket" "bucket" {
  bucket = "test-bucket-wsp"
}

resource "aws_transfer_server" "sftp" {
  identity_provider_type = "SERVICE_MANAGED"

  endpoint_type = "VPC"
  endpoint_details {
    address_allocation_ids = [aws_eip.public_ip.id]
    security_group_ids     = [aws_security_group.sg1.id]
    subnet_ids             = [aws_subnet.subnet_main.id]
    vpc_id                 = aws_vpc.vpc_main.id
  }

  tags = {
    Name = "sftp_transfer_server"
  }
}

data "aws_iam_role" "sftp_role" {
  name = "sftp_aws_role"
}


resource "aws_transfer_user" "sftp1" {
  server_id = aws_transfer_server.sftp.id
  user_name = "sftpuser1"
  role = data.aws_iam_role.sftp_role.arn
  home_directory = "/${data.aws_s3_bucket.bucket.id}"
}
  
resource "aws_transfer_ssh_key" "sftp_key" {
  server_id = aws_transfer_server.sftp.id
  user_name = aws_transfer_user.sftp1.user_name
  body = <<EOF
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8xtB+J0JLosHQVMOOFFrF7oCnJRcm/9MMo54nD2uH5Ws725YBSZIUjk1IgijadSiDi9rGOSlpqQDtQAUqZCVpRuo+4Ge6Rn/qctqrhYq2nhN2o609RWnsy7TphSTAD8sZvCSsD18WPY/JWuWMciJTf0p4FswKYo5hxtDrr59NpGS9qSffQ6ieIWg83V9kkaxekfi4ey1Dt2evSsJ4C+/6SnXICOtw9tgtrNmhlsOYkAKvpI//VESrHuj9qC2eXsupy9a6k+yyN8/nj/ss/DsmhZ3I1K1R5uO6qTtuZyBOs0S4ZZorbwCyKo8MstPXiLafoFUxquwfFVJvX4PVdkNngIwp3sg+vXmEGHqLzEl5YUaFCxDm+2VcN6lpwiOWlBnWCDWM30QYozMDiRbDcBwm4md4o9wyKmiswU3TUfwKH1BFrYdb+8rCtFOouI0MDRFgl7WnUS/XFdZwMLfQixPgamOJpRSNAXxcQ6TxkZTKdn6DlPGZvf6kE7jUNnWCmVR1Hi/8FL2+cGhSJlzNabUB5lvuRWHfsJExleNUcVIW4ZJARXo+fWMGVisZH3SAiFzlmH2pfEsNULcNz37s91aze2QQIHrr0750/n3MV/hDDXksL8yJ58CY4MZ+dARG6jeA8A5hPiTdNhhUSP6FAOpUgMEShWIQzE6Dg8SyZdL3Vw== parke@DESKTOP-G9RR6HK
  EOF
  
}
