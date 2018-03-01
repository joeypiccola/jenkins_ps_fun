$ad_user = (Get-ChildItem -Path (env:cred_ad_ + ($env:win_domain.replace('.','')) + '_USR')).value
$ad_pass = (Get-ChildItem -Path (env:cred_ad_ + ($env:win_domain.replace('.','')) + '_PSW')).value

switch ($vcenter -replace '^.+?\.(.+)$','$1')
{
    'ad.piccola.us' {
        $vcenter_user = (Get-ChildItem -Path (env:cred_vcenter_ + 'adpiccolaus_USR')).value
        $vcenter_pass = (Get-ChildItem -Path (env:cred_vcenter_ + 'adpiccolaus_PSW')).value
    }
}

$credentials = [PSCustomObject]@{
    vcenter_user = $vcenter_user
    vcenter_pass = $vcenter_pass
    ad_user      = $ad_user
    ad_pass      = $ad_user
}

Write-Output $credentials