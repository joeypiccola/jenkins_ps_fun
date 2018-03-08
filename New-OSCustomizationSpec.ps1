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

$string_210 = 'a' * 210
$string_211 = 'a' * 211
$string_212 = 'a' * 212
$string_213 = 'a' * 213
$string_214 = 'a' * 214
$string_215 = 'a' * 215
$string_216 = 'a' * 216
$string_217 = 'a' * 217
$string_218 = 'a' * 218
$string_219 = 'a' * 219


# build an array of run once commands 
$selectedConfigRunOnce = @(
    "cmd /c echo $string_210 >> c:\deploy\filexx_250.txt",
    "cmd /c echo $string_211 >> c:\deploy\filexx_251.txt",
    "cmd /c echo $string_212 >> c:\deploy\filexx_252.txt",
    "cmd /c echo $string_213 >> c:\deploy\filexx_253.txt",
    "cmd /c echo $string_214 >> c:\deploy\filexx_254.txt",
    "cmd /c echo $string_215 >> c:\deploy\filexx_255.txt",
    "cmd /c echo $string_216 >> c:\deploy\filexx_256.txt",
    "cmd /c echo $string_217 >> c:\deploy\filexx_257.txt",
    "cmd /c echo $string_218 >> c:\deploy\filexx_258.txt",
    "cmd /c echo $string_219 >> c:\deploy\filexx_259.txt"
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