#Requires -Version 7


<#
enum appUrls {
    /host_app
    /ddi
    /ddi.dns.data
    /anycast
    /atcfw
    /atcep
    /atcdfp
    /atclad
}
#>

class BloxOne {
    # Hide these from general display because of the API key
    hidden [string] $apiKey
    hidden [hashtable] $headers

    [string] $apiVersion
    [string] $baseUrl

    [string] $appUrl = $null
    [string] $objectUrl = $null
    [psobject] $result = $null

    ################################################
    # Hidden constructors to set defaults where applicable
    hidden Init([string]$appUrl) {
        $this.appUrl = $appUrl
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

    # Perform a GET operation
    [boolean] GetRequest ([string] $obj)
    {
        # Clear/initialize the result buffer
        $this.result = @{}

        if ([string]::IsNullOrEmpty($this.appUrl)) {
            Write-Warning "appUrl does not have a value"
            return $false
        }
        
        # Verify $obj begins with a "/"
        if ($obj -match '^/') {
            Write-Verbose "$obj begins with '/'"
        } else {
            Write-Warning "$obj does not begin with '/'"
            return $false
        }

        # Build the full URL or what we are looking for
        $this.objectUrl = $this.baseUrl + "/api/" + $this.appUrl + "/" + $this.apiVersion + "$obj"
        Write-Verbose "objectUrl = $($this.objectUrl)"

        # This is for an inherited object but it may be something custom as well
        if ([string]::IsNullOrEmpty($this.objectUrl) -ne $true ) {
            
            try {
                [PSObject] $data  = Invoke-RestMethod -Method Get -Uri $this.objectUrl -Headers $this.headers -ContentType "application/json"

                # Some results are "result" and some are "results"
                if ($data.result.length) {
                    $this.result = $data.result
                } elseif ($data.results.length) {
                    $this.result = $data.results
                }
                
            } catch {
                # Get the actual message provided by the provider
                $reasonPhrase = $_.Exception.Message
                Write-Error $reasonPhrase
                return $false
            }
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