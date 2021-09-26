[CmdletBinding()]
param (
    $applicationId,
    $secretkey,
    $tenantId,
    $resourceGroupName = "azure-stack",
    $vmname = "metadata"
)

az login --service-principal --username $applicationId --password $secretkey --tenant $tenantId
az vm show -g $resourceGroupName -n $vmname  