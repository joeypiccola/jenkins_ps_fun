function Invoke-JSON
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateSet("Get","Set")]
        [string]$Action
        ,
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path -Path $_ -IsValid})]
        [string]$JSONFile
        ,
        [Parameter(Mandatory)]
        [string]$Property
        ,
        [Parameter()]
        [string]$Value
    )

    if (!(Test-Path $JSONFile)) {
        Add-Content -Path $JSONFile -Value '{}'
    }

    $json = Get-Content -Path $JSONFile | ConvertFrom-Json

    switch ($Action)
    {
        'Get' {
            if ($json.$property) {
                Write-Output $json.$property
            } else {
                Write-Output $false
            }
        }
        'Set' {
            if ($json.$property) {
                Add-Member -InputObject $json -NotePropertyName $property -NotePropertyValue $value -Force
                $json | ConvertTo-Json | Set-Content -Path $JSONFile
            } else {
                Add-Member -InputObject $json -NotePropertyName $property -NotePropertyValue $value
                $json | ConvertTo-Json | Set-Content -Path $JSONFile
            }
        }
    }
}