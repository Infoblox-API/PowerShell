# Project Creation
$ProjectName = 'BloxOne'
$Path = "C:\Users\Don Smith\Google Drive\Scripts\Github\PowerShell\$ProjectName"
$ModuleName = "BloxOne-DDI"
$Author = "Don Smith"
$Description = "PowerShell module to work with Infoblox product APIs"

# Create the module and private function directories
mkdir $Path\$ModuleName
mkdir $Path\$ModuleName\Private
mkdir $Path\$ModuleName\Public
mkdir $Path\$ModuleName\en-US # For about_Help files
mkdir $Path\Tests

#Create the module and related files
New-Item "$Path\$ModuleName\$ModuleName.psm1" -ItemType File
New-Item "$Path\$ModuleName\$ModuleName.Format.ps1xml" -ItemType File
New-Item "$Path\$ModuleName\en-US\about_$ModuleName.help.txt" -ItemType File
New-Item "$Path\Tests\$ModuleName.Tests.ps1" -ItemType File
New-ModuleManifest -Path $Path\$ModuleName\$ModuleName.psd1 `
                   -RootModule $ModuleName.psm1 `
                   -Description $Description `
                   -PowerShellVersion 5.0 `
                   -Author $Author `
                   -FormatsToProcess "$ModuleName.Format.ps1xml"

# Copy the public/exported functions into the public folder, private functions into private folder