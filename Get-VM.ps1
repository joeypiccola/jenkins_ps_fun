[CmdletBinding()]
Param (
    [Parameter()]
    [string]$usr
    ,
    [Parameter()]
    [string]$psw
)

Get-Module -ListAvailable VMware* | Import-Module | Out-Null
Connect-VIServer -Server vcenter -User $usr -Password $psw
$vm = Get-VM nuget
Write-Output $vm.name
Disconnect-VIServer -Force -Server vcenter -Confirm:$false