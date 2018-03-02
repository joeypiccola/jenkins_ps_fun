[CmdletBinding()]
Param (
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vcenter_user
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vcenter_pass
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$ad_user	
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$ad_pass
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vcenter
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vmname
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$win_domain
)

$vmquery = $true
$adquery = $true

try {
    $vcentersecpasswd = ConvertTo-SecureString $vcenter_pass -AsPlainText -Force
    $vcentercreds = New-Object System.Management.Automation.PSCredential ($vcenter_user, $vcentersecpasswd)
    Get-Module -ListAvailable VMware* | Import-Module | Out-Null
    Connect-VIServer -Server $vcenter -Credential $vcentercreds -ErrorAction Stop
    $vm = Get-VM -Name $vmname -ErrorAction Stop
} catch {
    Disconnect-VIServer -Server $vcenter -Confirm:$false -Force
    $vmquery = $false
    Write-Warning $_.Exception.Message
}

try {
    $adsecpasswd = ConvertTo-SecureString $ad_pass -AsPlainText -Force
    $adcreds = New-Object System.Management.Automation.PSCredential ($ad_user, $adsecpasswd)
    $ad = Get-ADComputer -Identity $vmname -Credential $adcreds -Server $win_domain -ErrorAction Stop
} catch {
    $adquery = $false
    Write-Warning $_.Exception.Message
}

if (($adquery -eq $true) -or ($vmquery -eq $true)) {
    Write-Error 'object exists'
}