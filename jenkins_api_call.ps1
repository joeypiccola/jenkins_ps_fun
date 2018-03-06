#$cred = Get-Credential
#$i = 1
$i++
$disks = @()
<#
0 .. 4 | ForEach-Object{
    $disk = [PSCustomObject]@{
        size   = @(10..1000) | Get-Random 
        letter = [char](@(65..90) | Get-Random)
        label  = "mylabel_$_"
        au     = '4096'
    }
    $disks += $disk
}
#>
$disk_cfg = [PSCustomObject]@{
    disks = $disks
    profile = 'SQL'
    datastore = 'syno-vmware-iscsi-2'
}

$networking_cfg = [PSCustomObject]@{
    ip            = '10.0.5.100'
    netmask       = '255.255.255.0'
    gateway       = '10.0.5.1'
    dns_primary   = '10.0.3.21'
    dns_secondary = '10.0.3.22'
    dns_tertiary  = '8.8.8.8'
    portgroup     = 'vlan5'
}
$hardware_cfg = [PSCustomObject]@{
    cores = 1
    sockets = 2
    memory = 2
}

$request = [pscustomobject]@{
    vcenter        = 'vcenter.ad.piccola.us'
    datacenter     = 'basement'
    cluster        = 'bc1'
    role           = 'Member Server'
    os             = '12R2S'
    win_domain     = 'ad.piccola.us'
    vmname         = "JenkinsTest-$i"
    disk_cfg       = $disk_cfg
    hardware_cfg   = $hardware_cfg
    networking_cfg = $networking_cfg
}

$requestJSON = $request | ConvertTo-Json -Compress -Depth 3
$params = @{buildspec = $requestJSON}
Invoke-JenkinsJob -Uri 'http://jenkins.ad.piccola.us:8080' -Credential $cred -Parameters $params -Name 'vmware_test'