[CmdletBinding()]
Param (
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$ad_user	
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$ad_pass
    ,
    [Parameter()]
    [string]$vmname = $env:vmname
    ,
    [Parameter()]
    [string]$win_domain = $env:win_domain
    ,
    [Parameter()]
    [string]$ou
)

if ($win_domain -ne 'workgroup') {
    try {
        $adsecpasswd = ConvertTo-SecureString $ad_pass -AsPlainText -Force
        $adcreds = New-Object System.Management.Automation.PSCredential ($ad_user, $adsecpasswd)    
        New-ADComputer -Server $win_domain -Credential $adcreds -Path $ou -Name $vmname
    } catch {
        Write-Error $_.Exception.Message
    }
} else {
    Write-Warning 'workgroup detected, skipping stage ad computer'
}