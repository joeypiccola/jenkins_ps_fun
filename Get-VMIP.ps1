﻿[CmdletBinding()]
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
    [Parameter(ValueFromPipelineByPropertyName)]
    [pscustomobject]$networking_cfg
    ,
    [Parameter(Mandatory)]
    [ValidateSet('DHCP','static')]
    [string]$stage
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'

# connect to vmware
$vcenter_pass_sec = ConvertTo-SecureString $vcenter_pass -AsPlainText -Force
$vcenter_cred = New-Object System.Management.Automation.PSCredential ($vcenter_user, $vcenter_pass_sec)
Get-Module -ListAvailable VMware* | Import-Module
Connect-VIServer -Server $vcenter -Credential $vcenter_cred

Write-Information "Get-VMIP is currenlty running under the context: $stage"

try {
    # wait 10 min for the vm to post tool's status
    $vm = Get-VM -Name $vmname
    Wait-Tools -VM $vm -TimeoutSeconds 600

    # depending on the stage (e.g. whether or not we're waiting for the system to come up on DHCP or the destired static)
    # alter the logic that detects what IP is detected (e.g. look for a IP post coming up or look for the specified static IP)
    switch ($stage) {
        'DHCP' {
            # wait 10 min, checking every 5 sec for VM to post to tools an ipv4 address
            $timeoutSeconds = 600
            $waitIntervalSeconds = 5
            $maxIntervals = $timeoutSeconds / $waitIntervalSeconds # this is 600 / 5 = 120
            $i = 1
            while (($i -le $maxIntervals) -and ($ip -eq $null)) {
                Write-Information "Current interval $i, $($i * $waitIntervalSeconds) of $timeoutSeconds sec elapsed so far"
                $vm = Get-VM -Name $vmname
                # get IPs that are IPV4 (e.g. 4 indexs split on a dot) and that are not APIPA
                $ip = $vm.Guest.IPAddress | ?{$_.split('.').count -eq 4} | ?{$_.split('.')[0] -ne '169'}
                if ($ip -ne $null)
                {
                    Write-Information "The system has posted the following, assumed DHCP, IPv4 address: $ip"
                    # now that we have the IP get out of the while loop and go to the finally block
                    continue
                }
                sleep -Seconds $waitIntervalSeconds
                $i++
                if ($i -eq $maxIntervals)
                {
                    # maxIntervals reached, error out
                    Write-Error "The system never posted a DHCP address after waiting $timeoutSeconds seconds"
                }
            }
        }
        'static' {
            # wait 15 min, checking every 5 sec for VM to post to tools an ipv4 address
            $timeoutSeconds = 900
            $waitIntervalSeconds = 5
            $maxIntervals = $timeoutSeconds / $waitIntervalSeconds # this is 900 / 5 = 180
            $i = 1
            while (($i -le $maxIntervals) -and ($ip -ne $networking_cfg.ip)) {
                Write-Information "Current interval $i, $($i * $waitIntervalSeconds) of $timeoutSeconds sec elapsed so far"
                $vm = Get-VM -Name $vmname
                # get IPs that are IPV4 (e.g. 4 indexs split on a dot) and that are not APIPA
                $ip = $vm.Guest.IPAddress | ?{$_.split('.').count -eq 4} | ?{$_.split('.')[0] -ne '169'}
                if ($ip -eq $networking_cfg.ip)
                {
                    Write-Information "The system has posted the following, assumed static, IPv4 address: $ip"
                    # now that we have the IP get out of the while loop and go to the finally block
                    continue
                }
                sleep -Seconds $waitIntervalSeconds
                $i++
                if ($i -eq $maxIntervals)
                {
                    # maxIntervals reached, error out
                    Write-Error "The system never posted the static IP address $($networking_cfg.ip) after waiting $timeoutSeconds seconds"
                }
            }
        }
    }
} catch {
    Write-Error $_.Exception.Message
} finally {
    Disconnect-VIServer -Force -Confirm:$false
}