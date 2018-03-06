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
    [string]$cspec_name
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'

$vcenter_pass_sec = ConvertTo-SecureString $vcenter_pass -AsPlainText -Force
$vcenter_cred = New-Object System.Management.Automation.PSCredential ($vcenter_user, $vcenter_pass_sec)
Get-Module -ListAvailable VMware* | Import-Module
Connect-VIServer -Server $vcenter -Credential $vcenter_cred

$get = Get-OSCustomizationSpec -Name $cspec_name -ErrorAction SilentlyContinue

if ($get.count -eq 1) {
    try {
        $get | Remove-OSCustomizationSpec -Confirm:$false
    } catch {
        Write-Error $_.Exception.Message
    } finally {
        Disconnect-VIServer -Force -Confirm:$false
    }
} else {
    Disconnect-VIServer -Force -Confirm:$false
    # up for debate as to whether or not this should be a terminating error. the sepc we made
    # should be available to remove, if it's not there assume something went wrong...
    Write-Error "No OSCustomizationSpec was found to remove: `"$vcenter_user\$cspec_name`""
}