Set-ExecutionPolicy Bypass -Scope Process -Force

Invoke-Expression ((Net-Object System.Net.WebClient).DownloadString('https://chocolately.org/install.ps1'))
choco install googlechrome -y
choco instasll putty -y
choco install winscp -y
choco install sysinternals -y
choco install bginfo -y

mkdir -Path "c:\LabSetup"
mkdir -Path "c:\NTDS"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/parkerws/terraform/master/StarterLab/config/DomainSetup.ps1" -OutFile "C:\LabSetup\DomainSetup.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/parkerws/terraform/master/StarterLab/config/DomainStructure.ps1" -OutFile "C:\LabSetup\DomainStructure.ps1"

Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled True 
Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv6-In)" -Enabled True

Install-WindowsFeature -name Ad-Domain-Services -IncludeManagementTools
Install-WindowsFeature -name DNS -IncludeManagementTools
