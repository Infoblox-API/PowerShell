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
        CSP BaseURL as System.String
        Application as System.String
        API Version as System.String

    .Outputs
        baseUrl as System.String

    .Parameter cspBaseUrl
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

      [Parameter(Mandatory=$False,Position=0)]  
      [string]$cspBaseUrl = "https://csp.infoblox.com",

      [Parameter(Mandatory=$True,Position=1)]  
      [string]$cspApp,

      [Parameter(Mandatory=$False,Position=2)]  
      [string]$apiVersion = "v1"
    )

  BEGIN {
    Write-Debug "PsBoundParameters:"
    $PSBoundParameters.GetEnumerator() | ForEach-Object { Write-Debug $_ }
    if ($PSBoundParameters['Debug']) {
        $DebugPreference = 'Continue'
    }
    Write-Debug "DebugPreference: $DebugPreference"
    Write-Verbose "$($MyInvocation.MyCommand.Name):: Function started"

    # Build the complete base API URL with the supplied information
    $baseUrl = "$cspBaseUrl/api/$cspApp/$apiVersion"
    Write-Verbose "baseUrl = $baseUrl"
  }

  PROCESS {
    #Write-Verbose "$($MyInvocation.MyCommand.Name):: Processing"
  }

  END {
    Write-Verbose "$($MyInvocation.MyCommand.Name):: Function ended"
    return $baseUrl
  }

}
