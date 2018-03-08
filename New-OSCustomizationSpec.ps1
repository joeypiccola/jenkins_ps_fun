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

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'

# take the provided disk config and convert it to a flat json string
$disk_cfg_file_contents = $disk_cfg | ConvertTo-Json -Compress

# take the provided networking config and convert it to a flat json string
$networking_cfg_file_contents = $networking_cfg | ConvertTo-Json -Compress

# take the provided role and replace the spaces with an underscore
$role_script = $role.Replace(' ','_').ToLower()

$string_245 = 'a' * 245
$string_245 = 'a' * 246
$string_245 = 'a' * 247
$string_245 = 'a' * 248
$string_245 = 'a' * 249
$string_245 = 'a' * 250
$string_245 = 'a' * 251
$string_245 = 'a' * 252
$string_245 = 'a' * 253
$string_245 = 'a' * 254


# build an array of run once commands 
$selectedConfigRunOnce = @(
    "cmd /c echo $string_245 >> c:\deploy\filexx_285.txt",
    "cmd /c echo $string_246 >> c:\deploy\filexx_286.txt",
    "cmd /c echo $string_247 >> c:\deploy\filexx_287.txt",
    "cmd /c echo $string_248 >> c:\deploy\filexx_288.txt",
    "cmd /c echo $string_249 >> c:\deploy\filexx_289.txt",
    "cmd /c echo $string_250 >> c:\deploy\filexx_290.txt",
    "cmd /c echo $string_251 >> c:\deploy\filexx_285.txt",
    "cmd /c echo $string_252 >> c:\deploy\filexx_291.txt",
    "cmd /c echo $string_253 >> c:\deploy\filexx_292.txt",
    "cmd /c echo $string_254 >> c:\deploy\filexx_293.txt"
    #"cmd /c echo $networking_cfg_file_contents >> c:\deploy\netcfg.json",
    #"cmd /c echo $disk_cfg_file_contents >> c:\deploy\diskcfg.json"
    #"c:\deploy\callps.bat command `"iwr http://nuget.ad.piccola.us:8081/chocogit.ps1 -UseBasicParsing | iex`"",
    #"c:\deploy\callps.bat command `"& 'c:\Program Files\Git\cmd\git.exe' clone -b master https://github.com/joeypiccola/vmware-runonce.git c:\deploy\config`"",
    #"c:\deploy\callps.bat file `"c:\deploy\config\$win_domain\$role_script.ps1`""
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