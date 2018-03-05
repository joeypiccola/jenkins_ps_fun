#$cred = Get-Credential
#region disks
$disks = @()
0 .. 4 | ForEach-Object{
    $disk = [PSCustomObject]@{
        size   = @(10..1000) | Get-Random 
        letter = [char](@(65..90) | Get-Random)
        label  = "mylabel_$_"
        au     = '4096'
    }
    $disks += $disk
}
$disk_cfg = [PSCustomObject]@{
    disks = $disks
    profile = 'SQL'
    datastore = 'syno-vmware-iscsi-2'
}
#endregion
#region other
$networking_cfg = [PSCustomObject]@{
    ip            = '10.10.10.10'
    netmask       = '255.255.255.0'
    gateway       = '10.10.10.1'
    dns_primary   = '1.1.1.1'
    dns_secondary = '2.2.2.2'
    dns_tertiary  = '3.3.3.3'
    portgroup     = 'vlan5'
}
$hardware_cfg = [PSCustomObject]@{
    cores = 1
    sockets = 2
    memory = 2
}
#endregion

$request = [pscustomobject]@{
    vcenter        = 'vcenter.ad.piccola.us'
    datacenter     = 'basement'
    cluster        = 'bc1'
    role           = 'Member Server'
    os             = '12R2S'
    win_domain     = 'ad.piccola.us'
    vmname         = 'nuget'
    disk_cfg       = $disk_cfg
    hardware_cfg   = $hardware_cfg
    networking_cfg = $networking_cfg
}

$requestJSON = $request | ConvertTo-Json -Compress -Depth 3
$params = @{buildspec = $requestJSON}
Invoke-JenkinsJob -Uri 'http://jenkins.ad.piccola.us:8080' -Credential $cred -Parameters $params -Name 'vmware_test'