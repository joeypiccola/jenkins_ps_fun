$builddata = Get-Content '.\builddata.json' | ConvertFrom-Json

# if the build is for a workgroup then do not define ad credentials as they do not exist
if ($builddata.win_domain -ne 'workgroup') {
    # take 'ad.contoso.com' and make it 'adcontosocom'
    # remove all dots from win_domain var
    # generate the env var $env:cred_ad_adcontosocom_USR and get the value
    # generate the env var $env:cred_ad_adcontosocom_PSW and get the value
    $ad_key = ($builddata.win_domain.replace('.',''))
    $ad_user = (Get-ChildItem -Path ('env:cred_ad_' + $ad_key + '_USR')).value
    $ad_pass = (Get-ChildItem -Path ('env:cred_ad_' + $ad_key + '_PSW')).value
}

# take 'vcenter.dallas.contoso.com' and make it 'adcontosocom'
# remove all dots and hostname from vcenter var
# generate the env var $env:cred_vcenter_dallascontosocom_USR and get the value
# generate the env var $env:cred_vcenter_dallascontosocom_PSW and get the value
$vcenter_key = ($builddata.vcenter -replace '^.+?\.(.+)$','$1').Replace('.','')
$vcenter_user = (Get-ChildItem -Path ('env:cred_vcenter_' + $vcenter_key + '_USR')).value
$vcenter_pass = (Get-ChildItem -Path ('env:cred_vcenter_' + $vcenter_key + '_PSW')).value

$localadmin_user = (Get-ChildItem -Path ('env:cred_localadmin_USR')).value
$localadmin_pass = (Get-ChildItem -Path ('env:cred_localadmin_PSW')).value

$builddata | Add-Member -NotePropertyName 'vcenter_user' -NotePropertyValue $vcenter_user
$builddata | Add-Member -NotePropertyName 'vcenter_pass' -NotePropertyValue $vcenter_pass
$builddata | Add-Member -NotePropertyName 'ad_user' -NotePropertyValue $ad_user
$builddata | Add-Member -NotePropertyName 'ad_pass' -NotePropertyValue $ad_pass
$builddata | Add-Member -NotePropertyName 'localadmin_user' -NotePropertyValue $localadmin_user
$builddata | Add-Member -NotePropertyName 'localadmin_pass' -NotePropertyValue $localadmin_pass

Write-Output $builddata