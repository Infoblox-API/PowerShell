Function Get-BaseUrl {
    <#
    .Synopsis
        Constructs the BaseURL for all BloxOne API calls

    .Description
        Creates the base URL for all application specific API calls

    .Notes
        Author      : Don Smith <dsmith@infoblox.com>
        Version     : 1.0 - 2020-07-29 - Initial release

    .Inputs
        CSP Hostname URI as System.String
        Application as System.String
        API Version as System.String

    .Outputs
        baseUrl as System.String

    .Parameter cspHostname
        Specifies the URI path to the Cloud Services Portal (CSP).
        Defaults to "https://csp.infoblox.com"

    .Parameter cspApp
        Specifies the app where the data is hosted
        Required as input

    .Parameter apiVersion
        Specifies the API version
        Defaults to "v1"

    .Example
        $baseUrl = Get-BaseUrl "https://csp.infoblox.com/" "ddi" "v1"
        -----------
        Description
        Accesses the production CSP system, DDI application, using API version 1

    .Example
        $baseUrl = Get-BaseUrl -cspApp "ddi"
        -----------
        Description
        Accesses the production CSP system, DDI application, using API version 1

    .Link
        Get-BaseUrl
    #>

  [CmdletBinding()]
    Param(

      [Parameter(ValueFromPipeline=$True,Mandatory=$False,Position=0)]  
      [string]$cspHostname = "https://csp.infoblox.com",

      [Parameter(ValueFromPipeline=$True,Mandatory=$False,Position=1)]  
      [string]$cspApp,

      [Parameter(ValueFromPipeline=$True,Mandatory=$False,Position=2)]  
      [string]$apiVersion = "v1"
    )

  BEGIN {
      Write-Debug "[DEBUG:Get-BaseUrl] Begin"
      $baseUrl = "$cspHostname/api/$cspApp/$apiVersion"
  }

  PROCESS {
  }

  END {
    Write-Debug "[DEBUG:Get-BaseUrl] return results"
    return $baseUrl
  }

}
