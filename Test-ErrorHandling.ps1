$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'


try {
    if (1 -eq 1) {
        Write-Error 'boom'
    }
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