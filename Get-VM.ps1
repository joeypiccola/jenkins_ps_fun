[CmdletBinding()]
Param (
    [Parameter()]
    [string]$vcenter_user
    ,
    [Parameter()]
    [string]$vcenter_pass
    ,
    [Parameter()]
    [string]$adjoin_user	
    ,
    [Parameter()]
    [string]$adjoin_pass
    ,
    [Parameter()]
    [string]$vcenter
    ,
    [Parameter()]
    [string]$vmname        
)

Get-Module -ListAvailable VMware* | Import-Module | Out-Null
Connect-VIServer -Server $vcenter -User $vcenter_user -Password $vcenter_pass -erroraction stop
$vm = Get-VM $vmname
Write-Output $vm
Disconnect-VIServer -Force -Server $vcenter -Confirm:$false
Get-ADComputer -Identity $vmname -properties * | select name, samaccountname, pa*