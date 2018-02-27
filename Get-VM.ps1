[CmdletBinding()]
Param (
    [Parameter()]
    [string]$usr
    ,
    [Parameter()]
	[string]$psw
    ,
    [Parameter()]
    [string]$vmname	
)

Get-Module -ListAvailable VMware* | Import-Module | Out-Null
Connect-VIServer -Server vcenter -User $usr -Password $psw
$vm = Get-VM nuget
Write-Output $vmname
Disconnect-VIServer -Force -Server vcenter -Confirm:$false