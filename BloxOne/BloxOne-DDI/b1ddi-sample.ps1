### Sample PowerShell Script for BloxOne DDI
#
# Error checking is needed
# A basic module should be created



Import-Module “./BloxOne-DDI.psm1”


#
# Read the INI file for a base configuration
#
$iniFile = Get-IniContent ".\bloxone.ini"


#
# Set these values at the beginning of each script file or globally
#
$appUri = "/ddi"
$baseUri = $iniFile.AMS.url + "/api" + $appUri + "/" + $iniFile.AMS.api_version
$baseUri

$headers = @{
    "Authorization" = "Token " + $iniFile.AMS.api_key
}
$headers

#
# Change these as necessary
#
$objectUri = “$baseUri/dhcp/server”
$objectUri

#
# Get the object(s)
#
$Response = Invoke-RestMethod -Method ‘Get’ -Uri $objectUri -Headers $headers

#
# Loop through the objects and display the name
#
for ($i=0; $i -lt $Response.results.Length; $i++) {
    "#$i " + $Response.results[$i].name
}

#
# Display the first object details
#
$firstObj = $Response.results[0]
"Name of the first object is " + $firstObj.name
$firstObj


$url = $iniFile.Sandbox.url + $appUri + $iniFile.Sandbox.api_version
$url
