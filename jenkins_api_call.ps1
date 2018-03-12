#$cred = Get-Credential
#$i = 1
$i++
$disks = @()
$letters = @('R','S','T','U','V')
0 .. 4 | ForEach-Object{
    $disk = [PSCustomObject]@{
        size   = @(1..2) | Get-Random 
        letter = $letters[$_]
        label  = "Label-$_-$($letters[$_])"
        au     = '4096'
    }
    $disks += $disk
}

$disk_cfg = [PSCustomObject]@{
    disks = $disks
    profile = 'Custom'
    datastore = 'syno-vmware-iscsi-2'
}

$networking_cfg = [PSCustomObject]@{
    ip          = "10.0.5.$(@(100..240) | Get-Random -count 1)"
    netmask     = '255.255.255.0'
    gateway     = '10.0.5.1'
    dns_servers = @('10.0.3.21','10.0.0.22','8.8.8.8')
    portgroup   = 'VLAN5_deployment_testing'
}
$hardware_cfg = [PSCustomObject]@{
    cores = 1
    sockets = 4
    memory = 6
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
$params = @{
    buildspec = $requestJSON
}
Invoke-JenkinsJob -Uri 'http://jenkins.ad.piccola.us:8080' -Credential $cred -Parameters $params -Name 'vmware_test'