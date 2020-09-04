#Requires -Version 7.0

### Sample PowerShell Script for BloxOne DDI
### Author:  Don Smith
### Author-Email: dsmith@infoblox.com

#Using module ".\Class\bloxone.psm1"
$VerbosePreference = 'continue'
#$VerbosePreference = 'SilentlyContinue'

# Remove old functions/Cmdlets from the current module
Write-Output "Removing old instances of functions"
Get-Module BloxOne-DDI | Remove-Module
clear

# Load the current module
Import-Module “.\BloxOne-DDI.psd1”

# Define the complete list of valid application API URLs
enum appUrls {
    host_app
    ddi 
    dns_data #likely an invalid value (converting to ddi.dns.data below per current documentation)
    anycast
    #atcfw
    #atcep
    #atcdfp
    #atclad
}

class BloxOne {
    # Hide these from general display because of the API key
    hidden [string] $apiKey
    hidden [hashtable] $headers

    [string] $apiVersion
    [string] $baseUrl

    [appUrls] $appUrl
    [string] $objectUrl = $null
    [psobject] $result = $null

    ################################################
    # Hidden constructors to set defaults where applicable
    hidden Init(
        [appUrls]$appUrl
    ) {
        if ($appUrl -eq "dns_data") {
            $this.appUrl = "ddi.dns.data"
        } else {
            $this.appUrl = $appUrl
        }
    }

    ################################################
    # CONSTRUCTORS

    # Default constructor
    BloxOne() {
        $this.baseUrl = "https://csp.infoblox.com"
        $this.apiVersion = "v1"
    }

    # Constructor with specific values provided
    BloxOne(
        [string]$apiKey,
        [string]$baseUrl,
        [string]$apiVersion
    )
    {
        $this.SetBaseValues($apiKey, $baseUrl, $apiVersion)
    }

    # Constructor with config file and section provided
    BloxOne(
        [string]$configFile = "bloxone.ini",
        [string]$configSection = "BloxOne"
    )
    {
        [hashtable]$iniConfig = Get-ConfigInfo -configFile $configFile

        # Define the header information
        if ($iniConfig.ContainsKey($configSection)) {
            $this.SetBaseValues($iniConfig[$configSection].api_key, $iniConfig[$configSection].url, $iniConfig[$configSection].api_Version)
        } else {
            Write-Warning "The section '$configSection' was not found."
        }
    }

    # Method to set or update values of key fields
    [void] SetBaseValues (
        [string]$apiKey,
        [string]$baseUrl,
        [string]$apiVersion
    )
    {
        $this.apiKey = $apiKey
        $this.headers = @{"content-type" = "application/json"; "Authorization" = "Token $($this.apiKey)"}
        $this.baseUrl = $baseUrl
        $this.apiVersion = $apiVersion
    }

    # Method override for ToString()
    [string] ToString ()
    {
        return "baseUrl: " + $this.baseUrl + ", apiVersion: " + $this.apiVersion
    }

    # Perform a GET request without arguments or payload
    [boolean] GetRequest ([string] $obj)
    {
        [string] $urlArgs = $null
        [string] $jsonBody = $null

        return $this.GetRequest($obj, $urlArgs, $jsonBody)
    }

    # Perform a GET request with arguments
    [boolean] GetRequest ([string] $obj, [string] $urlArgs)
    {
        [string] $jsonBody = $null

        return $this.GetRequest($obj, $urlArgs, $jsonBody)
    }

    # Perform a GET request with arguments and a payload
    [boolean] GetRequest ([string] $obj, [string] $urlArgs, [string] $jsonBody)
    {
        # Clear/initialize the result buffer
        $this.result = @{}

        # Make sure we have an app API to use
        if ([string]::IsNullOrEmpty($this.appUrl)) {
            # Eventually change this to an error
            Write-Warning "appUrl does not have a value"
            return $false
        }

        # Verify $obj begins with a "/"
        if ($obj -match '^/') {
            Write-Verbose "$obj begins with '/'"
        } else {
            $obj = "/" + $obj
            Write-Verbose "$obj updated to include leading '/'"
        }

        # Build the object URL or what we are looking for
        $this.objectUrl = $this.baseUrl + "/api/" + $this.appUrl + "/" + $this.apiVersion + "$obj"

        # Add the arguments to the URL
        if ([string]::IsNullOrEmpty($urlArgs)) {
            # write this code
        }

        Write-Verbose "objectUrl = $($this.objectUrl)"

        # This is for an inherited object but it may be something custom as well
        if ([string]::IsNullOrEmpty($this.objectUrl) -ne $true ) {

            try {
                #[PSObject] $data  = Invoke-RestMethod -Method Get -Uri $this.objectUrl -Headers $this.headers -ContentType "application/json"
                # Branch here if we have a payload to include in the request
                [PSObject] $data  = Invoke-RestMethod -Method Get -Uri $this.objectUrl -Headers $this.headers

                # Some results are "result" and some are "results"
                if ($data.result.length) {
                    $this.result = $data.result
                } elseif ($data.results.length) {
                    $this.result = $data.results
                }

            } catch {
                # Get the actual message from the provider
                $reasonPhrase = $_.Exception.Message
                Write-Error $reasonPhrase
                return $false
            }
            Write-Verbose "# of results: $($this.result.length)"

        }
        return $true
    }
}

class OPH : BloxOne {
    # Default constructor
    OPH() : base() {
        $this.Init("host_app")
    }

    # Constructor with specific values provided
    OPH([string]$apiKey, [string]$baseUrl, [string]$apiVersion) : base($apiKey, $baseUrl, $apiVersion)
    {
        $this.Init("host_app")
    }

    # Constructor with config file and section provided
    OPH([string]$configFile, [string]$configSection) : base($configFile, $configSection)
    {
        $this.Init("host_app")
    }
}

class DDI : BloxOne {
    # Default constructor
    DDI() : base() {
        $this.Init("ddi")
    }

    # Constructor with specific values provided
    DDI([string]$apiKey, [string]$baseUrl, [string]$apiVersion) : base($apiKey, $baseUrl, $apiVersion)
    {
        $this.Init("ddi")
    }

    # Constructor with config file and section provided
    DDI([string]$configFile, [string]$configSection) : base($configFile, $configSection)
    {
        $this.Init("ddi")
    }
}

class DNS : BloxOne {
    # Default constructor
    DNS() : base() {
        #$this.Init("dns_data")
        $this.Init("ddi")
    }

    # Constructor with specific values provided
    DNS([string]$apiKey, [string]$baseUrl, [string]$apiVersion) : base($apiKey, $baseUrl, $apiVersion)
    {
        #$this.Init("dns_data")
        $this.Init("ddi")
    }

    # Constructor with config file and section provided
    DNS([string]$configFile, [string]$configSection) : base($configFile, $configSection)
    {
        #$this.Init("dns_data")
        $this.Init("ddi")
    }
}


#--------------------
# Test Code
#--------------------
<#
Write-Output "<<--------------------------------------------->>"
Write-Output "BloxOne object with INI file and section"
$b3 = [BloxOne]::New("bloxone.ini", "AMS")
$b3.Init("host_app")
Write-Output "BloxOne: values = " + $b3
Write-Output "BloxOne: headers = "
$b3.headers
Write-Output "BloxOne:  GET"
$b3.GetRequest("/on_prem_hosts")
Write-Output "BloxOne: result length = " + $oph3.result.length

if( [string]::IsNullOrEmpty($b3.result) -ne $true ) {
    #$b3.result
    #$results = ConvertFrom-Json $b3.result -Depth 10
    #$results
}
#>

<#
Write-Output "<<--------------------------------------------->>"
Write-Output "OPH object with INI file and section"
$oph3 = [OPH]::New("bloxone.ini", "Sandbox")
Write-Output "OPH: values = " + $oph3
Write-Output "OPH: headers = "
$oph3.headers
Write-Output "OPH: GET"
$oph3.GetRequest("/on_prem_hosts")
Write-Output "OPH: result length = " + $oph3.result.length
#>

Write-Output "<<--------------------------------------------->>"
Write-Output "DDI object with INI file and section"
$ddi3 = [DDI]::New("bloxone.ini", "Sandbox")
Write-Output "DDI: values = "
$ddi3
Write-Output "DDI: headers = "
$ddi3.headers
Write-Output "DDI: GET"
$ddi3.GetRequest("/ipam/ip_space")
Write-Output ("DDI: result length = " + $ddi3.result.length)

if( [string]::IsNullOrEmpty($ddi3.result) -ne $true ) {
    $ddi3.result
    #$results = ConvertFrom-Json $b3.result -Depth 10
    #$results
}

$objID = $ddi3.result[0].id
$objName = $ddi3.result[0].name
Write-Output "ID of $objName is: $objID"

$ddi3.GetRequest($objID)
$ddi3


Write-Output "<<--------------------------------------------->>"
Write-Output "DNS object with INI file and section"
$dns1 = [DNS]::New("bloxone.ini", "Sandbox")
Write-Output "DNS: values = "
$dns1
Write-Output "DNS: GET"
$dns1.GetRequest("/dns/record")
#$dns1.result


<#
# Create an object using our BloxOne class
$b1 = [BloxOne]::New()
$b1
$b1.SetBaseValues("abcdefg", "https://something.csp.infoblox.com", "v99")
$b1

$b3 = [BloxOne]::New("a123456", "https://awesome.csp.infoblox.com", "v5")
$b3
#>
