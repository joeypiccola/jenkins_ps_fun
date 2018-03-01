[CmdletBinding()]
Param (
    [Parameter()]
    [string]$vcenter_user
    ,
    [Parameter()]
    [string]$vcenter_pass
    ,
    [Parameter()]
    [string]$adjoin_user	
    ,
    [Parameter()]
    [string]$adjoin_pass
    ,
    [Parameter()]
    [string]$vcenter
    ,
    [Parameter()]
    [string]$vmname        
)

$vmquery = $true
$adquery = $true

try {
    $vcentersecpasswd = ConvertTo-SecureString $vcenter_pass -AsPlainText -Force
    $vcentercreds = New-Object System.Management.Automation.PSCredential ($vcenter_user, $vcentersecpasswd)
    Get-Module -ListAvailable VMware* | Import-Module | Out-Null
    Connect-VIServer -Server $vcenter -Credential $vcentercreds -ErrorAction Stop
    $vm = Get-VM -Name $vmname -ErrorAction Stop
} catch {
    Disconnect-VIServer -Server $vcenter -Confirm:$false -Force
    $vmquery = $false
    Write-Warning $_.Exception.Message
}

try {
    $adsecpasswd = ConvertTo-SecureString $adjoin_pass -AsPlainText -Force
    $adcreds = New-Object System.Management.Automation.PSCredential ($adjoin_user, $adsecpasswd)
    $ad = Get-ADComputer -Identity $vmname -ErrorAction Stop -Credential $adcreds
} catch {
    $adquery = $false
    Write-Warning $_.Exception.Message
}

if (($adquery -eq $true) -or ($vmquery -eq $true)) {
    Write-Error 'object exists'
}