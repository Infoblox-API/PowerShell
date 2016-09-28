Import-Module .\Infoblox-DDI.psd1
Write-Host ""

$GridMaster = Read-Host "Grid Master"
$Username   = Read-Host "Username"

Connect-IBGridMaster $GridMaster $Username -ask -force -Debug

Show-IBSessionVariables
Write-Host ""

# Fail tests
Set-IBMaxResults 0
Set-IBMaxResults 1000001
Set-IBWapiVersion "2.3.1"
Set-IBWapiVersion "v 2.3.1"

# Success tests
Set-IBMaxResults 2000
Set-IBWapiVersion "v2.3.1"

Find-IBNetwork 192.168.1.0 | Format-Table

$test_data = Get-IBNetwork network/ZG5zLm5ldHdvcmskMTkyLjE2OC4xLjAvMjQvMA:192.168.1.0/24/Company%201 -json -Debug
#$test_data
