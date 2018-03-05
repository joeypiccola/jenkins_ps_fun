# pull in the pipeline param build spec and convert it from json
$builddata = $env:buildspec | ConvertFrom-Json
#$builddata = '{"vcenter":"vcenter.ad.piccola.us","win_domain":"ad.piccola.us","vmname":"fake_04","disk_cfg":[{"size":396,"letter":"D","label":"mylabel_0","au":"4096"},{"size":372,"letter":"M","label":"mylabel_1","au":"4096"},{"size":765,"letter":"W","label":"mylabel_2","au":"4096"},{"size":359,"letter":"P","label":"mylabel_3","au":"4096"},{"size":479,"letter":"L","label":"mylabel_4","au":"4096"}],"networking_cfg":{"ip":"10.10.10.10","netmask":"255.255.255.0","gateway":"10.10.10.1","dns_primary":"1.1.1.1","dns_secondary":"2.2.2.2","dns_tertiary":"3.3.3.3"}}'
#$builddata = $builddata | ConvertFrom-Json

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
$builddata | ConvertTo-Json -Depth 5 | Add-Content -Path '.\builddata.json'