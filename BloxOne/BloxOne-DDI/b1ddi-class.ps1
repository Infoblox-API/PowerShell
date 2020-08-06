#Requires -Version 7

### Sample PowerShell Script for BloxOne DDI
### Author:  Don Smith
### Author-Email: dsmith@infoblox.com
### Version: 2020-08-05 Initial release

#Using module ".\Class\bloxone.psm1"
#$VerbosePreference = 'continue'

# Load the current module
Import-Module “.\BloxOne-DDI.psd1”

class BloxOne {
    # Hide these from general display because of the API key
    hidden [string] $apiKey
    hidden [hashtable] $headers

    [string] $apiVersion
    [string] $baseUrl

    [string] $appUrl = $null
    [string] $objectUrl = $null
    [psobject] $result = $null

    # Default constructor
    BloxOne() { }

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
            $this.apiKey = $iniConfig[$configSection].api_key
            $this.headers = @{ "Authorization" = "Token $($this.apiKey)" }

            $this.baseUrl = $iniConfig[$configSection].url
            $this.apiVersion = $iniConfig[$configSection].api_Version
        } else {
            Write-Warning "The API key '$configSection' was not found."
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

    # Perform a GET operation
    [void] GetRequest ([string] $obj)
    {
        # Verify $obj begins with a "/"
        # Write code for this
        $this.result = @{}

        # Build the full URL or what we are looking for
        $this.objectUrl = $this.baseUrl + "/api/" + $this.appUrl + "/" + $this.apiVersion + "$obj"
        Write-Verbose "objectUrl = $($this.objectUrl)"

        # This is for an inherited object but it may be something custom as well
        if ([string]::IsNullOrEmpty($this.objectUrl) -ne $true ) {
            
            try {
                [PSObject] $data  = Invoke-RestMethod -Method Get -Uri $this.objectUrl -Headers $this.headers -ContentType "application/json"
                $this.result = $data.result
            } catch {
                # Get the actual message provided by the provider
                $reasonPhrase = $_.Exception.Message
                Write-Error $reasonPhrase
            }
        }
    }
}




#--------------------
# Test Code
#--------------------


$b2 = [BloxOne]::New("bloxone.ini", "AMS")
$b2
$b2.headers
$b2.appUrl = "host_app"
$b2.GetRequest("/on_prem_hosts")

if( [string]::IsNullOrEmpty($b2.result) -ne $true ) {
    $b2.result
    #$results = ConvertFrom-Json $b2.result -Depth 10
    #$results    
}


<#
# Create an object using our BloxOne class
$b1 = [BloxOne]::New()
$b1
$b1.SetBaseValues("abcdefg", "https://something.csp.infoblox.com", "v99")
$b1

$b3 = [BloxOne]::New("a123456", "https://awesome.csp.infoblox.com", "v5")
$b3
#>