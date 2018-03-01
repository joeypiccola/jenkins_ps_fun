# take 'ad.contoso.com' and make it 'adcontosocom'
# remove all dots from win_domain var
$ad_key = ($env:win_domain.replace('.',''))
$ad_user = (Get-ChildItem -Path ('env:cred_ad_' + $ad_key + '_USR')).value
$ad_pass = (Get-ChildItem -Path ('env:cred_ad_' + $ad_key + '_PSW')).value

# take 'vcenter.ad.contoso.com' and make it 'adcontosocom'
# remove all dots and hostname from vcenter var
$vcenter_key = ($env:vcenter -replace '^.+?\.(.+)$','$1').Replace('.','')
$vcenter_user = (Get-ChildItem -Path ('env:cred_vcenter_' + $vcenter_key + '_USR')).value
$vcenter_pass = (Get-ChildItem -Path ('env:cred_vcenter_' + $vcenter_key + '_PSW')).value

$credentials = [PSCustomObject]@{
    vcenter_user = $vcenter_user
    vcenter_pass = $vcenter_pass
    ad_user      = $ad_user
    ad_pass      = $ad_user
}

Write-Output $credentials