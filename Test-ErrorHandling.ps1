$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'


try {
    Write-Host '1'
    continue
    Write-Host 'did i see this'
} catch {
    Write-Error $_.Exception.Message
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