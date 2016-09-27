<#
	.Synopsis
		Get an Infoblox object based on the reference passed.
		
	.Description
		Get the referenced object and any additional columns requested.
		
	.Parameter _ref
		The object reference obtained from a 'find' operation
		
	.Parameter _return_fields
		Additional columns to retrieve aside from those returned by default

	.Outputs
		An object array of name/value pairs
		
	.Example
		Get-Object 192.168.1.0 network
	
		Find a network that matches the address 192.168.1.0
		
#>

function script:Get-Object {
    Param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
            [string]$_ref,
        [Parameter(Mandatory=$false,Position=1)]
            [string]$_return_fields
    )

    BEGIN {
        if (!$ib_session) {
            Write-Host "[ERROR] [Get-Object] Try creating a session first. 'Connect-GridMaster'"
            return $false
        }

        # Initialize our counter and hashtable
        [hashtable[]]$data_array = $null
    }

    PROCESS {
        Write-Verbose "[Get-Object] [$_ref] [$_return_fields]"
        Write-Debug "[DEBUG] [Get-Object] _ref           = $_ref"
        Write-Debug "[DEBUG] [Get-Object] _return_fields = $_return_fields"

        $uri_return_type = "_return_type=json-pretty"
        $uri = "$ib_uri_base/$_ref"+'?'+$uri_return_type

        if ($_return_fields) {
            $uri = "$uri"+'&'+"_return_fields%2b=$_return_fields"
        }

		if ($script:ib_max_results) { $uri = "$uri"+'&'+"_max_results=$script:ib_max_results" }

        Write-Debug "[DEBUG-URI] [Get-Object] $uri"

        # Try to obtain the data and print an error message if there is one
        try {
            $local_results = Invoke-WebRequest -Uri $uri -Method Get -WebSession $ib_session
        } catch {
            Write-Host "[ERROR] [Get-Object] There was an error getting the data."
            Write-Host "[ERROR-URI] [Get-Object] $uri"
            Write-Host $_.ErrorDetails
        }  

        # Grab only the content portion of the returned object
        $obj_content = $local_results.Content

        # Deserialize the JSON data into something manageable
        $data = $obj_content | IB-ConvertFrom-JSON

		Write-Debug "[DEBUG] [Get-Object] Got data '$data'"

        $data_array += $data
		Write-Debug "[DEBUG] [Get-Object] Array '$data_array'"
    }

    END {
		Write-Debug "[DEBUG] [Get-Object] Returning data as is"
		return $data_array
    }
}