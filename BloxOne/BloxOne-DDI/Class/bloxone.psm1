#Requires -Version 7


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
