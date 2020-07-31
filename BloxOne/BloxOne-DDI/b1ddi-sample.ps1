### Sample PowerShell Script for BloxOne DDI
### Author:  Don Smith
### Author-Email: dsmith@infoblox.com
### Version: 2020-07-30 Initial release

# Remove the module if loaded so we can reload it
# For debugging and testing purposes
Write-Host "Removing old instances of functions"
Get-Module BloxOne-DDI | Remove-Module
clear

# Load the current module
Import-Module “.\BloxOne-DDI.psd1”
#Write-Host ""
#Get-Command -Module BloxOne-DDI
#Write-Host ""

# Read the INI file for the base configuration
$iniConfig = Get-ConfigInfo
Write-Output "Available config sections"
foreach ($key in $iniConfig.Keys) {
  Write-Output "    $key"
}

# Now build the Authorization header using the appropriate API Key from the config
$headers = @{
    "Authorization" = "Token " + $iniConfig.AMS.api_key
}

# Get a hash table of all current DDI related API URLs
# This example doesn't use any custom values
[hashtable]$h = Get-DDIUrls
#Get-DDIUrls

# Change these as necessary
$dhcpServers = $h.ipamUrl + "/dhcp/server”

# Get the object(s)
$serverList = Invoke-RestMethod -Method ‘Get’ -Uri $dhcpServers -Headers $headers

# Loop through the objects and display the name
for ($i=0; $i -lt $serverList.results.Length; $i++) {
    "#$i " + $serverList.results[$i].name
}

# Choose which section values we want to build the Url hashtable
[hashtable]$h1 = Get-DDIUrls $iniConfig.Sample.url $iniConfig.Sample.api_version
$url = $h1.ipamUrl
$url

Write-Output $iniConfig.Sample
