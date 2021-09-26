<#
*****************************************************************
Description:
This script helps to fetch the metadata of the VM installed in Azure with PublicIp

*****************************************************************
#Assumptions 
1. You have Public Ip configured for your VM Created in Azure 
2. Allowed traffice for ports 5985 (HTTP) and 5986 (HTTPS) in NSGs if you have attached to NSG
3. Enable winrm for remote communication
4. We are using username and password to communicate enter the session.
*****************************************************************
#Parameters

.publicIP
    -> Ip of the virtual machine which you wanted to get the metadata info
.NeededInfo
    -> path of the info which you wanted to fetch 
    ex: 1) compute
        2) "/network/nic/0"
.username
    -> username of the VM to login
.enterPassword
    -> passphrase of the VM to login


#>

param (

    $publicIP,
    $NeededInfo = "compute",
    $username,
    $enterPasswor

)    

$password = ConvertTo-SecureString $enterPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $password )
Enter-PSSession -ComputerName $publicIP -Credential $cred
    
Invoke-RestMethod –Headers @{"Metadata" = "true" } –URI "http://169.254.169.254/metadata/instance/$NeededInfo?api-version=2017-08-01" | ConvertTo-Json -Depth 100
