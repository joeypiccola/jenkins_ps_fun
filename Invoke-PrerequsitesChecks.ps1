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

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

$vmquery = $true
$adquery = $true

# connect to vmware
$vcenter_pass_sec = ConvertTo-SecureString $vcenter_pass -AsPlainText -Force
$vcenter_cred = New-Object System.Management.Automation.PSCredential ($vcenter_user, $vcenter_pass_sec)
Get-Module -ListAvailable VMware* | Import-Module
Connect-VIServer -Server $vcenter -Credential $vcenter_cred

try {
    Get-VM -Name $vmname
    Disconnect-VIServer -Server $vcenter -Confirm:$false -Force
} catch {
    Disconnect-VIServer -Server $vcenter -Confirm:$false -Force
    $vmquery = $false
    Write-Warning $_.Exception.Message
}

$ad_pass_sec = ConvertTo-SecureString $ad_pass -AsPlainText -Force
$ad_creds = New-Object System.Management.Automation.PSCredential ($ad_user, $ad_pass_sec) 

try {
    Get-ADComputer -Identity $vmname -Credential $ad_creds -Server $win_domain
} catch {
    $adquery = $false
    Write-Warning $_.Exception.Message
}

if (($adquery -eq $true) -or ($vmquery -eq $true)) {
    Write-Information "ADObject `"$vmname`" $adquery in $win_domain"
    Write-Information "VMObject `"$vmname`" $vmquery in $vcenter"
    exit 1
}