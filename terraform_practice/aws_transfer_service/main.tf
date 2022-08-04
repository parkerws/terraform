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
    from_port        = 22
    to_port          = 22
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

resource "aws_s3_bucket" "bucket" {
  bucket = "test-bucket-wsp"
}

resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
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

# data "aws_iam_role" "sftp_role" {
#   name = "sftp_aws_role"
# }

resource "aws_iam_role" "sftp_role" {
  name = "sftp_aws_role"
  assume_role_policy = <<EOF
  {
        "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "transfer.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "sftp_role_policy" {
  name = "sftp_aws_role_policy"
  role = aws_iam_role.sftp_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Sid = "AllowListingOfUserFolder",
        Effect = "Allow",
        Action = [
            "s3:ListBucket",
            "s3:GetBucketLocation"
        ]
        Resource = [
          "arn:aws:s3:::*"
          ]
    },
    {
        Sid = "HomeDirObjectAccess",
        Effect = "Allow",
        Action = [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetObjectACL",
                "s3:PutObjectACL"
        ]
        Resource = [
                "arn:aws:s3:::*"
        ]
    }]
  }) 
  

}


resource "aws_transfer_user" "sftp1" {
  server_id = aws_transfer_server.sftp.id
  user_name = "sftpuser1"
  role = aws_iam_role.sftp_role.arn
  home_directory = "/${aws_s3_bucket.bucket.id}"
}
  
resource "aws_transfer_ssh_key" "sftp_key" {
  server_id = aws_transfer_server.sftp.id
  user_name = aws_transfer_user.sftp1.user_name
  body = <<EOF
  ssh-rsa 
  EOF
  
}
