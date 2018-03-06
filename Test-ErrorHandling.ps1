$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'


try {
    1/0
    Write-Host 'does this run?'
} catch {
    Write-Error 'catch #1'
} finally {
    Write-Information 'cleaning up stuff #1'
}

try {
    1/1
} catch {
    Write-Error 'catch #2'
} finally {
    Write-Information 'cleaning up stuff #2'
}