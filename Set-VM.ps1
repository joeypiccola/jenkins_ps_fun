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
    [string]$datacenter
    ,
    [Parameter(ValueFromPipelineByPropertyName)]
    [pscustomobject]$hardware_cfg
    ,
    [Parameter(ValueFromPipelineByPropertyName)]
    [pscustomobject]$disk_cfg
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'

# connect to vmware
$vcenter_pass_sec = ConvertTo-SecureString $vcenter_pass -AsPlainText -Force
$vcenter_cred = New-Object System.Management.Automation.PSCredential ($vcenter_user, $vcenter_pass_sec)
Get-Module -ListAvailable VMware* | Import-Module
Connect-VIServer -Server $vcenter -Credential $vcenter_cred

try {
    $vm = Get-VM -Name $vmname
    if ($vm.count -eq 1) {
        # clear notes from packer
        $vm | Set-VM -Notes '' -Confirm:$false
        # set the memory
        $vm | Set-VM -MemoryGB $hardware_cfg.memory -Confirm:$false
        # set the cpu, if the cpu config is different than the baseline template then adjust the cpu config
        if (!(($hardware_cfg.sockets -eq 1) -and ($hardware_cfg.cores -eq 1)))
        {
            $selectedCores   = $hardware_cfg.cores
            $selectedSockets = $hardware_cfg.sockets
            $totalCores = $selectedCores * $selectedSockets
            $coresPerSocket = $totalCores / $selectedSockets
            $vm = Get-VM -Name $vmname
            $cpuspec = New-Object -TypeName PSCustomObject -Property @{numcorespersocket = $hardware_cfg.cores}
            ($vm).ExtensionData.ReconfigVM_Task($cpuspec)
            $vm | Set-VM -numcpu $totalCores -Confirm:$false
        }
        # add the disks
        foreach ($disk in $disk_cfg.disks) {
            New-HardDisk -VM $vm -CapacityGB $disk.size -StorageFormat Thick -Confirm:$false
        }
    } else {
        Write-Error "More than one VM was found when adjusting hardware settings: $vmname"
    }
} catch {
    Write-Error $_.Exception.Message
} finally {
    Disconnect-VIServer -Force -Confirm:$false
}