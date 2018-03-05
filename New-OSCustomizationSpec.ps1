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

$disk_cfg_file_contents = switch ($disk_cfg.disks.Count) {
    {$PSItem -gt 0} {
        Write-Output $disk_cfg.disks | ConvertTo-Json -Compress
    }
    default {
        Write-Output 'no disks'
    }
}

$networking_cfg_file_contents = $networking_cfg | ConvertTo-Json -Compress

if ($win_domain -eq 'workgroup') {
    $selectedConfigRunOnce = @(
        "cmd /c echo $networking_cfg_file_contents >> c:\deploy\netcfg.json",
        "cmd /c echo $disk_cfg_file_contents >> c:\deploy\diskcfg.json",
        "c:\deploy\callps.bat command `"iwr https://artifactory/artifactory/win-binaries/scripts/vmwarerunonce/chocogit.ps1 -UseBasicParsing | iex`"",
        "c:\deploy\callps.bat command `"& 'c:\Program Files\Git\cmd\git.exe' clone -b qa https://u:p@bitbucket/scm/iwp/runonce-vmware.git c:\deploy\config`"",
        "c:\deploy\callps.bat file `"c:\deploy\config\ms_non_dva_corp.ps1`""
    )
    
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
}
else {

}
Write-Output '---------'
Write-Output $disk_cfg_file_contents
Write-Output '---------'
Write-Output $networking_cfg_file_contents
Write-Output '---------'
foreach ($disk in $disk_cfg.disks) {
    Write-Output "The label is $($disk.label)"
}
Write-Output '---------'
Write-Output $disk_cfg.disks | fl *
Write-Output '---------'
Write-Output $disk_cfg.disks