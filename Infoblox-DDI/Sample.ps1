Import-Module .\Infoblox-DDI.psd1
Write-Host ""

$GridMaster = Read-Host "Grid Master"
$Username   = Read-Host "Username"

Connect-IBGridMaster $GridMaster $Username -ask -force

Show-IBSessionVariables
Write-Host ""
