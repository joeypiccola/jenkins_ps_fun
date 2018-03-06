# pull in the pipeline param build spec and convert it from json
$builddata = $env:buildspec | ConvertFrom-Json
# create the name of the OSCustomizationSpec
$builddata | Add-Member -NotePropertyName 'cspec_name' -NotePropertyValue ('ISG-Dyn-Spec_' + (Get-Random -Maximum 20000 -Minimum 10000))
# build teh name of the template to be used
$builddata | Add-Member -NotePropertyName 'template_name' -NotePropertyValue (($builddata.vcenter.substring(0,4) + 'isgtmp' + $builddata.os).toupper())
# get the value of the OU
switch ($builddata.win_domain) {
    'ad.piccola.us' {
        $ou = 'OU=JenkinsDeploymentTesting,OU=Test,OU=LabStuff,OU=Servers,DC=ad,DC=piccola,DC=us'
    }
    'cis.com' {
        $ou = 'OU=Test,OU=Servers,DC=cis,DC=com'
    }
    default {
        $ou = "no OU found for $win_domain"
    }
}
$builddata | Add-Member -NotePropertyName 'ou' -NotePropertyValue $ou
# write it to a file
$builddata | ConvertTo-Json -Depth 3 | Add-Content -Path '.\builddata.json'