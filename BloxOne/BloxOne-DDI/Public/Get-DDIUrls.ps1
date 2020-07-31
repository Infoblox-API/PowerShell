Function Get-DDIUrls {
  <#
    .Synopsis
      Constructs the BaseURL for all BloxOne API calls

    .Description
      Creates the base URL for all application specific API calls

    .Notes
      Author    : Don Smith <dsmith@infoblox.com>
      Version   : 1.0 - 2020-07-29 - Initial release

    .Inputs
      CSP Hostname URI as System.String
      API Version as System.String

    .Outputs
      System.Collections.Specialized.OrderedDictionary

    .Parameter cspHostname
      Specifies the URI path to the Cloud Services Portal (CSP).
      Defaults to "https://csp.infoblox.com"

    .Parameter apiVersion
      Specifies the API version
      Defaults to "v1"

    .Example
      $baseUrl = Get-BaseUrl "https://csp.infoblox.com/" "v1"
      -----------
      Description
      Accesses the production CSP system, all applications, using API version 1

    .Example
      $baseUrl = Get-BaseUrl
      -----------
      Description
      Accesses the production CSP system, all applications, using API version 1

    .Link
      Get-BaseUrl
  #>

  [CmdletBinding()]
    Param(
      [Parameter(ValueFromPipeline=$True,Mandatory=$False,Position=0)]  
      [string]$cspHostname = "https://csp.infoblox.com",

      [Parameter(ValueFromPipeline=$True,Mandatory=$False,Position=1)]  
      [string]$apiVersion = "v1",

      [Parameter(Mandatory=$False)]
      [hashtable]$iniSection
    )

  BEGIN {
    Write-Debug "[DEBUG:Get-DDIUrls] Begin"

    # Build the list of apps that will be needed for creating the URLs
    [hashtable]$cspApps = @{ipamUrl = "ddi"; dnsAppUrl = "ddi.dns.data"; hostAppUrl = "host_app"}

    # Loop through the apps and create the Url
    [hashtable]$hashUrl = @{}

    $cspApps.GetEnumerator() | ForEach-Object {
      # Store the values to work with later
      $keyName = $_.Name
      $appName = $_.Value

      # Build the URL for the specific app
      $appUrl = "$cspHostname/api/$appName/$apiVersion"
      Write-Debug "key = $keyName, app = $appName, url = $appUrl"

      # Add the app URL to the app so we can index it later
      $hashUrl[$keyName] = $appUrl
    }

  }

  PROCESS {
  }

  END {
    Write-Debug "[DEBUG:Get-DDIUrls] return results"
    return [hashtable]$hashUrl;
  }

}
