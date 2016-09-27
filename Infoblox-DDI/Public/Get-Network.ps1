<#
	.Synopsis
		Get an Infoblox network based on the reference passed.
		
	.Description
		Get the referenced network from the Grid database.
		
	.Parameter _ref
		The network reference obtained from a 'find' operation
		
	.Parameter json
		Converts the data results to JSON format on return
		
	.Outputs
		An object array of name/value pairs
		
	.Example
		Get-Network $ref
	
		Get a network that has the reference indicated
		
#>

function script:Get-Network {
    Param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
            [string]$_ref,
		[Parameter(Mandatory=$false,Position=1)]
			[switch]$json
    )

    BEGIN {
        [hashtable[]]$data_array = $null
    }

    PROCESS {
        Write-Verbose "[Get-Network] [$_ref] [$json]"
        # Specify the extra fields to return
        $return_fields = "comment,extattrs,members"

        # Get the data being requested
		Write-Debug "[Get-Network] Retrieve network object"
        $local_results = Get-Object -_ref $_ref -_return_fields $return_fields

        # Add the data to our array
		Write-Debug "[Get-Network] Append results with previous"
        $data_array += $local_results
    }

    END {
        if ($json) {
		    Write-Debug "[Get-Network] return results in JSON format"
            return $data_array | ConvertTo-JSON -Depth 4
        } else {
		    Write-Debug "[Get-Network] return results"
            return $data_array
        }
    }
}