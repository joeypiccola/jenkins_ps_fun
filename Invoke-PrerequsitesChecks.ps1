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

Get-Module -ListAvailable VMware* | Import-Module | Out-Null
Connect-VIServer -Server $vcenter -User $vcenter_user -Password $vcenter_pass -erroraction stop

try {
    $vm = Get-VM -Name $vmname -ErrorAction Stop
} catch {
    Disconnect-VIServer -Server $vcenter -Confirm:$false -Force
    $vmquery = $false
    Write-Error $_.Exception.Message
}

try {
    $secpasswd = ConvertTo-SecureString $adjoin_pass -AsPlainText -Force
    $mycreds = New-Object System.Management.Automation.PSCredential ($adjoin_user, $secpasswd)
    $ad = Get-ADComputer -Identity $vmname -ErrorAction Stop -Credential $mycreds
} catch {
    $adquery = $false
    Write-Error $_.Exception.Message
}