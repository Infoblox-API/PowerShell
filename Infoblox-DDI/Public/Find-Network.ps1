<#
	.Synopsis
		Search for an Infoblox network and return a list of results
		
	.Description
		Requires a search string to find the network (generally all of or a portion of the address)
		
	.Parameter search_string
		A string in URI compatible format
		
	.Parameter return_fields
		A list of comma separated return fields to be included in the results.

	.Outputs
		An array of results
		
	.Example
		Find-Network 192.168.1.0 network
		Find-Network -search_string 192.168.1.0
	
		Find a network that matches the address 192.168.1.0
		
	.Example
		Find-Network 192.168
		
		Find all networks that contain 192.168 in the address

#>

#
# May need a separate function to create the search string
#   EAs: *Building=my_building
#   * = %2A
#


function script:Find-Network {
    Param (
        [Parameter(Mandatory=$true,Position=0)]
            [string]$search_string,
		[Parameter(Mandatory=$false,Position=1)]
			[string]$return_fields = $null
    )

    BEGIN {
		Write-Debug "[DEBUG:Find-Network] Begin"
		# Check to make sure the $return_fields value is comma separated
		$fields_array = $return_fields.Split(",").Trim()
		$return_fields = $fields_array -join ","

		# Add the return fields to the search string
		
    }

    PROCESS {

	}

    END {
        Write-Verbose "[Find-Network] $search_string"
        $local_results = script:Find-Object -search_string $search_string -objtype network

        return $local_results
    }
}