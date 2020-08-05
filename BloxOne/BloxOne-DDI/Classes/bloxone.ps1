#Requires -Version 7


class BloxOne {
    [string] hidden $apiKey
    [hashtable] hidden $headers

    [string] $apiVersion
    [string] $baseUrl

    # Default constructor
    BloxOne() { }

    # Constructor to load values from the config file
    BloxOne(
        [string]$configFile = "bloxone.ini",
        [string]$configSection = "BloxOne"
    ) {
        [hashtable]$iniConfig = Get-ConfigInfo -configFile $configFile

        # Define the header information
        if ($iniConfig.ContainsKey($configSection)) {
            $this.apiKey = $iniConfig[$configSection].api_key
            $this.headers = @{"content-type" = "application/json"; "Authorization" = "Token $this.apiKey}"}
        } else {
            Write-Warning "An API key was not found."
        } 
        
    }
}