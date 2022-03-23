Set-ExecutionPolicy Bypass -Scope Process -Force

Invoke-Expression ((Net-Object System.Net.WebClient).DownloadString('https://chocolately.org/install.ps1'))
choco install googlechrome -y
choco instasll putty -y
choco install winscp -y
choco install sysinternals -y
choco install bginfo -y

mkdir -Path "c:\LabSetup"
mkdir -Path "c:\NTDS"

