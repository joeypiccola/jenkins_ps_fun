[CmdletBinding()]
Param (
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vcenter_user
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vcenter_pass
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$ad_user	
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$ad_pass
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$workgroup_user	
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$workgroup_pass
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vcenter
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$vmname
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$role
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$win_domain
    ,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]$cspec_name
    ,
    [Parameter(ValueFromPipelineByPropertyName)]
    [pscustomobject]$disk_cfg
    ,
    [Parameter(ValueFromPipelineByPropertyName)]
    [pscustomobject]$networking_cfg
)
Add-Content -Path C:\deploy\diskcfg.json -Value

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'

# take the provided disk config and convert it to a flat json string
$disk_cfg_file_contents = $disk_cfg | ConvertTo-Json -Compress

# take the provided networking config and convert it to a flat json string
$networking_cfg_file_contents = $networking_cfg | ConvertTo-Json -Compress

# take the provided role and replace the spaces with an underscore
$role_script = $role.Replace(' ','_').ToLower()

# build an array of run once commands 
$selectedConfigRunOnce = @(
    #"cmd /c echo $networking_cfg_file_contents >> c:\deploy\netcfg.json",
    #"cmd /c echo $disk_cfg_file_contents >> c:\deploy\diskcfg.json"
    "cmd.exe /C Powershell.exe -ExecutionPolicy Bypass Add-Content -Path C:\deploy\netcfg.json -Value $networking_cfg_file_contents"
    "cmd.exe /C Powershell.exe -ExecutionPolicy Bypass Add-Content -Path C:\deploy\diskcfg.json -Value $disk_cfg_file_contents",
    "c:\deploy\callps.bat command `"iwr http://nuget.ad.piccola.us:8081/chocogit.ps1 -UseBasicParsing | iex`"",
    "c:\deploy\callps.bat command `"& 'c:\Program Files\Git\cmd\git.exe' clone -b master https://github.com/joeypiccola/vmware-runonce.git c:\deploy\config`"",
    "c:\deploy\callps.bat file `"c:\deploy\config\$win_domain\$role_script.ps1`""
)

# build a param splat based on the provided win_domain for the vmware customization spec
if ($win_domain -eq 'workgroup') {
    $specSplat = @{
        Name                  = $cspec_name
        OSType                = 'Windows'
        ChangeSid             = $true
        OrgName               = 'Workgroup'
        FullName              = $workgroup_user
        AdminPassword         = $workgroup_pass
        AutoLogonCount        = 2
        GuiRunOnce            = $selectedConfigRunOnce
        Description           = 'this is a dyn generated on the fly customization spec'
        Workgroup             = 'workgroup'
        LicenseMode           = 'Perserver'
        LicenseMaxConnections = 5
        NamingScheme          = 'Fixed'
        NamingPrefix          = $vmname
    }
} else {
    $specSplat = @{
        Name                  = $cspec_name
        OSType                = 'Windows'
        ChangeSid             = $true
        OrgName               = $win_domain
        FullName              = $workgroup_user
        AdminPassword         = $workgroup_pass
        AutoLogonCount        = 2
        GuiRunOnce            = $selectedConfigRunOnce
        Description           = 'this is a dyn generated on the fly customization spec'
        Domain                = $win_domain
        DomainUserName        = $ad_user
        DomainPassword        = $ad_pass
        LicenseMode           = 'Perserver'
        LicenseMaxConnections = 5
        NamingScheme          = 'Fixed'
        NamingPrefix          = $vmname
    }
}

# connect to vmware
$vcenter_pass_sec = ConvertTo-SecureString $vcenter_pass -AsPlainText -Force
$vcenter_cred = New-Object System.Management.Automation.PSCredential ($vcenter_user, $vcenter_pass_sec)
Get-Module -ListAvailable VMware* | Import-Module
Connect-VIServer -Server $vcenter -Credential $vcenter_cred

# make the spec then try and get it
try {
    New-OSCustomizationSpec @specSplat
    sleep -Seconds 5
    Get-OSCustomizationSpec $cspec_name
} catch {
    Write-Error $_.Exception.Message
} finally {
    Disconnect-VIServer -Force -Confirm:$false
}