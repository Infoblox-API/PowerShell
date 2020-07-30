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
      DDI Urls as hashtable

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
      [string]$apiVersion = "v1"
    )

  BEGIN {
      Write-Debug "[DEBUG:Get-DDIUrls] Begin"
      $dnsAppUrl  = "$cspHostname/api/ddi.dns.data/$apiVersion"
      $hostAppUrl = "$cspHostname/api/host_app/$apiVersion"
      $ipamUrl    = "$cspHostname/api/ddi/$apiVersion"

      [hashtable]$hashUrl = @{ "dnsUrl" = $dnsAppUrl; "hostUrl" = $hostAppUrl; "ipamUrl" = $ipamUrl}
  }

  PROCESS {
  }

  END {
    Write-Debug "[DEBUG:Get-DDIUrls] return results"
    return $hashUrl
  }

}
