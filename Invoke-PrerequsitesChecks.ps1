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
$WarningPreference = 'Continue'

$vmquery = $true
$adquery = $true

# connect to vmware
$vcenter_pass_sec = ConvertTo-SecureString $vcenter_pass -AsPlainText -Force
$vcenter_cred = New-Object System.Management.Automation.PSCredential ($vcenter_user, $vcenter_pass_sec)
Get-Module -ListAvailable VMware* | Import-Module
Connect-VIServer -Server $vcenter -Credential $vcenter_cred

# try and get the vm from vmware. on error, write info not error. evalualte the results at the end
try {
    Get-VM -Name $vmname
} catch {
    $vmquery = $false
    Write-Information $_.Exception.Message
} finally {
    Disconnect-VIServer -Server $vcenter -Confirm:$false -Force
}

# define ad creds
$ad_pass_sec = ConvertTo-SecureString $ad_pass -AsPlainText -Force
$ad_creds = New-Object System.Management.Automation.PSCredential ($ad_user, $ad_pass_sec) 

# if the build is for a workgroup then do not check AD for an existing object
if ($win_domain -ne 'workgroup') {
    # try and get the object from ad. on error, write info not error. evalualte the results at the end
    try {
        Get-ADComputer -Identity $vmname -Credential $ad_creds -Server $win_domain
    } catch {
        $adquery = $false
        Write-Information $_.Exception.Message
    }
} else {
    $adquery = $false
}

Write-Information "ADObject `"$vmname`" $adquery in $win_domain"
Write-Information "VMObject `"$vmname`" $vmquery in $vcenter"
if (($adquery -eq $true) -or ($vmquery -eq $true)) {
    Write-Error 'Prerequsite checks failed: one or more objects exists'
}