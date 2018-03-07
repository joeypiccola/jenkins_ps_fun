[CmdletBinding()]
Param (
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vcenter_user
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vcenter_pass
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vcenter
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vmname
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$cluster
    ,
    [Parameter(ValueFromPipelineByPropertyName)]
    [pscustomobject]$networking_cfg
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'

# connect to vmware
$vcenter_pass_sec = ConvertTo-SecureString $vcenter_pass -AsPlainText -Force
$vcenter_cred = New-Object System.Management.Automation.PSCredential ($vcenter_user, $vcenter_pass_sec)
Get-Module -ListAvailable VMware* | Import-Module
Connect-VIServer -Server $vcenter -Credential $vcenter_cred

try{
    $clusterHost = Get-Cluster -Name $cluster | Get-VMHost | ?{ $_.ConnectionState -eq 'Connected' } | Get-Random -Count 1
    $clusterPortGroup = $clusterHost | Get-VDSwitch | Get-VDPortgroup | ?{$_.name -eq $networking_cfg.portgroup}
    if ($clusterPortGroup) {
        Get-VM -Name $vmname | Get-NetworkAdapter | Set-NetworkAdapter -Portgroup $clusterPortGroup -Confirm:$false
        sleep -Seconds 5
        $vm = Get-VM -Name vmname | Get-NetworkAdapter
        if ($vm.NetworkName -eq $networking_cfg.portgroup) {
            Write-Information "The desired port group $($clusterPortGroup.name) matches what is currenly on the VM $($vm.NetworkName)"
            continue
        } else {
            Write-Error "The desired port group $($clusterPortGroup.name) does not match what is currenly on the VM $($vm.NetworkName)"
        }
    } else {
        Write-Error "The port group $($networking_cfg.portgroup) was not found on $cluster"
    }
} catch {
    Write-Error $_.Exception.Message
} finally {
    Disconnect-VIServer -Force -Confirm:$false
}