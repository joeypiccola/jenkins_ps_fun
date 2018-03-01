[CmdletBinding()]
Param (
    [Parameter()]
    [string]$adjoin_user	
    ,
    [Parameter()]
    [string]$adjoin_pass
    ,
    [Parameter()]
    [string]$vmname
    ,
    [Parameter()]
    [string]$win_domain          
)

if ($win_domain -ne 'workgroup') {
    switch ($win_domain) {
        'ad.piccola.us' {
            $ou = 'OU=Test,OU=LabStuff,OU=Servers,DC=ad,DC=piccola,DC=us'
        }
        Default {}
    }

    try {
        $adsecpasswd = ConvertTo-SecureString $adjoin_pass -AsPlainText -Force
        $adcreds = New-Object System.Management.Automation.PSCredential ($adjoin_user, $adsecpasswd)    
        New-ADComputer -Server $win_domain -Credential $adcreds -Path $ou -Name $vmname
    } catch {
        Write-Error $_.Exception.Message
    }
} else {
    Write-Warning 'workgroup detected, skipping stage ad computer'
}