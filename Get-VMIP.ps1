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
    [Parameter(ValueFromPipelineByPropertyName)]
    [pscustomobject]$networking_cfg
    ,
    [Parameter(Mandatory)]
    [ValidateSet('DHCP','Static')]
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

switch ($stage)
{
    'DHCP' {
        $desiredIP = $null
        $errorMessage = "The system never posted a DHCP address after waiting $timeoutSeconds seconds"
    }
    'Static' {
        $desiredIP = $networking_cfg.ip
        $errorMessage = "The system never posted the static IP address $desiredIP after waiting $timeoutSeconds seconds"
    }
}

try {
    $vm = Get-VM -Name $vmname
    Wait-Tools -VM $vm -TimeoutSeconds 600

    # wait 10 min, checking every 5 sec for VM to post to tools an ipv4 address
    $timeoutSeconds = 600
    $waitIntervalSeconds = 5
    $maxIntervals = $timeoutSeconds / $waitIntervalSeconds # this is 600 / 5 = 120
    $i = 0
    while (($i -le $maxIntervals) -and ($ip -eq $desiredIP))
    {
        $vm = Get-VM -Name $vmname
        # get IPs that are IPV4 (e.g. 4 indexs split on a dot) and that are not APIPA
        $ip = $vm.Guest.IPAddress | ?{$_.split('.').count -eq 4} | ?{$_.split('.')[0] -ne '169'}
        if ($ip -ne $null)
        {
            Write-Information "The system has posted the following IPv4 address: $ip == $desiredIP"
            # now that we have the IP get out of the while loop and go to the finally block
            continue
        }
        sleep -Seconds $waitIntervalSeconds
        $i++
        if ($i -eq $maxIntervals)
        {
            # maxIntervals reached, error out
            Write-Error $errorMessage
        }
    }
} catch {
    Write-Error $_.Exception.Message
} finally {
    Disconnect-VIServer -Force -Confirm:$false
}