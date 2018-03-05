[CmdletBinding()]
Param (
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$ad_user	
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$ad_pass
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vmname
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$win_domain
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$ou
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'

$ad_pass_sec = ConvertTo-SecureString $ad_pass -AsPlainText -Force
$ad_creds = New-Object System.Management.Automation.PSCredential ($ad_user, $ad_pass_sec) 

if ($win_domain -ne 'workgroup') {   
    New-ADComputer -Server $win_domain -Credential $ad_creds -Path $ou -Name $vmname
} else {
    Write-Information "win_domain = `"$win_domain`", skipping New-ADComputer"
}