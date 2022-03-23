Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false `
-DomainMode "WinThreshold" `
-DomainName "wpark.lab" `
-DomainNetbiosName "wpark" `
-ForestMode "WinThreshold" `
-InstallDNS `
-NoRebootOnCompletion:$false `
-Force