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
)

Write-Host $vcenter_user -ForegroundColor Green
Write-Host $vcenter_pass -ForegroundColor Yellow
Write-Host $ad_user -ForegroundColor Magenta
Write-Host $ad_pass -ForegroundColor Cyan