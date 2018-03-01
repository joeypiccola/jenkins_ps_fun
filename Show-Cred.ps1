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

Write-Host "vcenter user is: $vcenter_user"
Write-Host "vcenter pass is: $vcenter_pass"
Write-Host "ad user is: $ad_user"
Write-Host "ad psss is: $ad_pass"
write-host "to host"
write-output "to output"