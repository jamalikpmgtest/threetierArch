[CmdletBinding()]
param (

    $JsonFile = ".\settings.json",
    $key = "accountcompanies/kpmg/name"
)


$keys = $key.Split("/")
$firstkey = $keys[0]
$secondkey = $keys[1]
$thirdkey = $keys[2]

$fileContent = Get-Content $JsonFile | ConvertFrom-JSON

$Information = $fileContent.$firstkey.$secondkey.$thirdkey

Write-Output "$Information"

