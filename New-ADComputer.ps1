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
)

if ($win_domain -ne 'workgroup') {
    switch ($win_domain) {
        'ad.piccola.us' {
            $ou = 'OU=Test,OU=LabStuff,OU=Servers,DC=ad,DC=piccola,DC=us'
        }
        Default {}
    }

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