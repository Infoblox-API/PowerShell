Function Get-ConfigInfo {
    <#
    .Synopsis
        Reads the config info from the provided INI file

    .Description
        Accepts a passed INI file or will read the bloxone.ini file in the current directory.
        If [Private] is found with a path key, the one additional INI file will be read.

    .Notes
        Author      : Don Smith <dsmith@infoblox.com>
        Version     : 1.0 - 2020-07-30 - Initial release

    .Inputs
        iniFileName as System.String

    .Outputs
        iniConfig as System.Collections.Specialized.OrderedDictionary

    .Parameter iniFileName
        Specifies the filename of the INI file to read
        Defaults to ".\bloxone.ini"

    .Example
        $iniConfig = Get-ConfigInfo "custom.ini"
        -----------
        Description
        Reads the custom.ini file in the local directory

    .Example
        $iniConfig = Get-ConfigInfo
        -----------
        Description
        Reads the bloxone.ini file in the local directory

    .Link
        Get-BaseUrl
    #>

  [CmdletBinding()]
    Param(

      [Parameter(ValueFromPipeline=$True,Mandatory=$False,Position=0)]  
      [string]$iniFileName = "bloxone.ini",

      # Tells us not to create the INI file if we don't find it
      [switch]
      $DoNotCreate
    )

  BEGIN {
    Write-Debug "[DEBUG:Get-ConfigInfo] Begin"

    # Check to make sure the file exists
    if (Test-Path $iniFileName) {
        Write-Debug "Found $iniFileName"

        $iniConfig = Get-IniContent $iniFileName

        # See if we need to load an additional INI file
        if ($iniConfig.Contains("Private")) {
            Write-Debug "Attempting to load alternate INI file"

            # Make sure the file exists that we are looking for
            if (Test-Path $iniConfig.Private.path) {
                $iniConfig = Get-IniContent $iniConfig.Private.path
            } else {
                Write-Debug "Alternate INI file specified not found"
            }
        }
    } else {
        Write-Warning "$iniFileName was not found"

        if (!$DoNotCreate) {
            # Create a template INI file since one did not exist
            $iniSection = @{“url”=”https://csp.infoblox.com”;”api_version”=”v1”;"api_key"="<your_personal_account_api_key_here>"}
            $iniContent = @{“BloxOne”=$iniSection}
            Out-IniFile -InputObject $iniContent -FilePath $iniFileName -Loose -Pretty

            $iniConfig = Get-ConfigInfo $iniFileName -DoNotCreate
        }
    }
  }

  PROCESS {
  }

  END {
    Write-Debug "[DEBUG:Get-ConfigInfo] return results"
    return $iniConfig
  }

}
