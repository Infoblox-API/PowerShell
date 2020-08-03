# Requires -Version 7
### Sample PowerShell Script for BloxOne DDI
### Author:  Don Smith
### Author-Email: dsmith@infoblox.com
### Version: 2020-08-03 Initial release

#$DebugPreference   = 'continue'
#$VerbosePreference = 'SilentlyContinue'


Write-Output @"
************************
>>> Beginning test <<<
************************
"@

<#
    Test #1: Pass only the cspApp value
    Expected Results:
        - generate a valid CSP URL using defaults and the provided app
#>
Write-Output "Test #1: Pass only cspApp and generate a valid CSP URL"
$myUrl = Get-BaseUrl -cspApp "ddi"
if ($myUrl -eq "https://csp.infoblox.com/api/ddi/v1") {
    Write-Output "Passed with correct construction of Url"
} else {
    Write-Warning "Wrong Url value created: $myUrl"
}


<#
    Test #2: Override the url default
    Expected Results:
        - generate a valid CSP URL
#>
# Read a random INI file
Write-OutPut "Test #2: Define a custom URL"
$myUrl = Get-BaseUrl "https://test3.csp.infoblox.com" "ddi"
if ($myUrl -eq "https://test3.csp.infoblox.com/api/ddi/v1") {
    Write-Output "Passed with correct construction of Url"
} else {
    Write-Warning "Wrong Url value created: $myUrl"
}

Write-Output @"
************************
>>> Test Complete <<<
************************
"@

exit


# Now build the Authorization header using the appropriate API Key from the config
$headers = @{
    "Authorization" = "Token " + $iniConfig.AMS.api_key
}

# Get a hash table of all current DDI related API URLs
# This example doesn't use any custom values
[hashtable]$h = Get-DDIUrls
[hashtable]$t1 = Get-DDIUrls -iniConfig $iniConfig #-iniSection "Sample"
#[hashtable]$t2 = Get-DDIUrls -iniConfig $iniConfig -iniSection "Sample" -cspBaseUrl "http://custom.csp.infoblox.com"


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


# Get us back to the test directory
Set-Location $testDir
