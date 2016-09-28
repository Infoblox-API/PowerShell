# Remove the module if loaded so we can reload it
Get-Module Infoblox-DDI | Remove-Module
clear

# Load the current module
Import-Module .\Infoblox-DDI.psd1
Write-Host ""
Get-Command -Module Infoblox-DDI
Write-Host ""


$GridMaster = Read-Host "Grid Master"
$Username   = Read-Host "Username"

Connect-IBGridMaster $GridMaster $Username -ask -force

Show-IBSessionVariables
Write-Host ""

# Fail tests
Write-Host "Fail Tests"
Set-IBMaxResults 0
Set-IBMaxResults 1000001
Set-IBWapiVersion "1.7"
Set-IBWapiVersion "v 1.7"

# Success tests
Write-Host "Success Tests"
Set-IBMaxResults 2000
Set-IBWapiVersion "v1.7"
Set-IBWapiVersion

Write-Host "Find network 192.168.1.0"
Find-IBNetwork 192.168.1.0 | Format-Table

Write-Host "Get network with ref"
#$test_data = Get-IBNetwork network/ZG5zLm5ldHdvcmskMTkyLjE2OC4xLjAvMjQvMA:192.168.1.0/24/Company%201 -json
#$test_data

