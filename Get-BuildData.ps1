$builddata = Get-Content '.\builddata.json' | ConvertFrom-Json

# take 'ad.contoso.com' and make it 'adcontosocom'
# remove all dots from win_domain var
# generate the env var $env:cred_ad_adcontosocom_USR and get the value
# generate the env var $env:cred_ad_adcontosocom_PSW and get the value
$ad_key = ($builddata.win_domain.replace('.',''))
$ad_user = (Get-ChildItem -Path ('env:cred_ad_' + $ad_key + '_USR')).value
$ad_pass = (Get-ChildItem -Path ('env:cred_ad_' + $ad_key + '_PSW')).value

# take 'vcenter.dallas.contoso.com' and make it 'adcontosocom'
# remove all dots and hostname from vcenter var
# generate the env var $env:cred_vcenter_dallascontosocom_USR and get the value
# generate the env var $env:cred_vcenter_dallascontosocom_PSW and get the value
$vcenter_key = ($builddata.vcenter -replace '^.+?\.(.+)$','$1').Replace('.','')
$vcenter_user = (Get-ChildItem -Path ('env:cred_vcenter_' + $vcenter_key + '_USR')).value
$vcenter_pass = (Get-ChildItem -Path ('env:cred_vcenter_' + $vcenter_key + '_PSW')).value

$workgroup_user = (Get-ChildItem -Path ('env:cred_workgroup_USR')).value
$workgroup_pass = (Get-ChildItem -Path ('env:cred_workgroup_PSW')).value

$builddata | Add-Member -NotePropertyName 'vcenter_user' -NotePropertyValue $vcenter_user
$builddata | Add-Member -NotePropertyName 'vcenter_pass' -NotePropertyValue $vcenter_pass
$builddata | Add-Member -NotePropertyName 'ad_user' -NotePropertyValue $ad_user
$builddata | Add-Member -NotePropertyName 'ad_pass' -NotePropertyValue $ad_pass
$builddata | Add-Member -NotePropertyName 'workgroup_user' -NotePropertyValue $workgroup_user
$builddata | Add-Member -NotePropertyName 'workgroup_pass' -NotePropertyValue $workgroup_pass

Write-Output $builddata