# pull in the pipeline param build spec and convert it from json
#$builddata = $env:buildspec | ConvertFrom-Json
$builddata = '{"vcenter":"vcenter.ad.piccola.us","win_domain":"ad.piccola.us","vmname":"fake_04","disks":[{"size":"30","letter":"H","label":"mylabel_0","au":"4096"},{"size":"30","letter":"H","label":"mylabel_1","au":"4096"},{"size":"30","letter":"H","label":"mylabel_2","au":"4096"},{"size":"30","letter":"H","label":"mylabel_3","au":"4096"},{"size":"30","letter":"H","label":"mylabel_4","au":"4096"}]}' | ConvertFrom-Json

# add what we need to it
$builddata | Add-Member -NotePropertyName 'cspec_name' -NotePropertyValue ('ISG-Dyn-Spec_' + (Get-Random -Maximum 20000 -Minimum 10000))

switch ($builddata.win_domain) {
    'ad.piccola.us' {
        $ou = 'OU=Test,OU=LabStuff,OU=Servers,DC=ad,DC=piccola,DC=us'
    }
    'cis.com' {
        $ou = 'OU=Test,OU=Servers,DC=cis,DC=com'
    }
}
$builddata | Add-Member -NotePropertyName 'ou' -NotePropertyValue $ou

# write it to a file
$builddata | ConvertTo-Json -Depth 4 | Add-Content -Path '.\builddata.json'