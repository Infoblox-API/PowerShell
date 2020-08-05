### Sample PowerShell Script for BloxOne DDI
### Author:  Don Smith
### Author-Email: dsmith@infoblox.com
### Version: 2020-08-05 Initial release

Using module "Classes\bloxone.ps1"

# Remove the module if loaded so we can reload it
# For debugging and testing purposes
Write-Host "Removing old instances of functions"
Get-Module BloxOne-DDI | Remove-Module
clear

# Load the current module
Import-Module “.\BloxOne-DDI.psd1”


# Create an object using our BloxOne class
$b1 = [BloxOne]::New()
$b1 | Get-Member -MemberType Properties

$b2 = [BloxOne]::New("bloxone.ini", "AMS")
$b2 | Get-Member -MemberType Properties
