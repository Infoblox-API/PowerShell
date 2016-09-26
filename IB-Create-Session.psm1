function script:IB-Ignore-Self-Signed-Certs {
########################################
# Do the following to ignore self-signed certificates
    add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}


function script:IB-Create-Session {
    <#
    .SYNOPSIS
        Establishes a session to an Infoblox Grid Master for all subsequent data calls.
        
    .PARAMETER grid_master 
        A single computer name or IP address.
        
    .EXAMPLE
        IB-Create-Session 192.168.1.2 admin infoblox
        Creates a connection to a Grid Master using default credentials and IP address.
        
    .EXAMPLE 
        IB-Create-Session 192.168.1.2 admin -ask_pw
        Creates a connection but allows entering the password securely (via prompt with masking).
        
    .NOTES
        This should be the first command run to ensure that a connection is established and global variables are properly configured.
        
    #>
    Param (
        [Parameter(Mandatory=$false,Position=0)]
            [string]$grid_master = "192.168.1.2",
        [Parameter(Mandatory=$false,Position=1)]
            [string]$username    = "admin",
        [Parameter(Mandatory=$false,Position=2)]
            [string]$password    = "infoblox",
        [Parameter(Mandatory=$false,Position=3)]
            [string]$wapi_ver    = "v1.3",
        [Parameter(Mandatory=$false,Position=4)]
            [string]$max_results = "_max_results=10000",
        [Parameter(Mandatory=$false)]
            [switch]$ask_pw
    )

    BEGIN {
        # Reset all script variables to null until a successful connection is established
        $script:ib_grid_name   = $null
        $script:ib_grid_master = $null
        $script:ib_grid_ref    = $null
        $script:ib_session     = $null
        $script:ib_uri_base    = $null
        $script:ib_username    = $null
        $script:ib_wapi_ver    = $null
    }

    PROCESS {   }

    END {
        ##########
        # Build the values that need built
        if ($ask_pw) {
            $secure_pw = $( Read-Host -Prompt "Enter password" -AsSecureString )
            Write-Host ""
        } else {
            $secure_pw = ConvertTo-SecureString $password -AsPlainText -Force
        }
        $credential = New-Object System.Management.Automation.PSCredential ($username, $secure_pw)
        $uri_base = "https://$grid_master/wapi/$wapi_ver"
        Write-Debug "[DEBUG] Create-Session:  URI base = $uri_base"

        ##########
        # Establish an initial connection
        #   Exit if there is an error
        $uri = "$uri_base/grid"
        try {
            $grid_obj = Invoke-RestMethod -Uri $uri -Method Get -Credential $credential -SessionVariable new_session
        } catch {
            Write-Host '[ERROR] There was an error connecting to the Grid.'
            Write-Host $_.ErrorDetails
            return $false
        }
    
        $s1        = $grid_obj._ref.IndexOf(":")
        $grid_name = $grid_obj._ref.Substring( $( $s1 + 1 ) )

        # Update global variables with new connection information
        $script:ib_grid_name   = $grid_name
        $script:ib_grid_master = $grid_master
        $script:ib_grid_ref    = $( $grid_obj._ref )
        $script:ib_session     = $new_session
        $script:ib_uri_base    = $uri_base
        $script:ib_username    = $username
        $script:ib_wapi_ver    = $wapi_ver

        Write-Verbose "### You are now connected to Grid: '$grid_name' ###"

        return $true
    }
}




# IB-Ignore-Self-Signed-Certs
# IB-Create-Session 192.168.1.2 admin -ask_pw
