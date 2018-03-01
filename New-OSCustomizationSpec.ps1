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
    [Parameter()]
    [string]$vcenter = $env:vcenter
    ,
    [Parameter()]
    [string]$vmname = $env:vmname
    ,
    [Parameter()]
    [string]$win_domain = $env:win_domain
)

. .\helperFunctions.ps1

$oi = Invoke-JSON -Action Get -JSONFile '.\envData.ps1' -Property 'RandomeNumber'

Write-Output "the random number is `"$oi`""