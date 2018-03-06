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

function Get-DatastoreClusters
{
    param
    (
        [CmdletBinding()]
        [Parameter(Mandatory)]
        [string]$Cluster
    )

    begin
    {
        # verify we can connect to the provided cluster.
        if (!($GetCluster = Get-Cluster -Name $Cluster))
        {
            Write-Error "Unable to connect to `"$Cluster`" to get DatastoreClusters"
        }
    }
    process
    {
        $pods = Get-Cluster $Cluster | Get-Datastore | ?{ $_.ParentFolderId -like 'StoragePod-group-*' } | sort -Unique -Property ParentFolderID
        Write-Verbose "Found $($pods.count)x datastore cluster on $cluster cluster."

        # if we have datastore clusters, use those. else, just go to the datastores
        if ($pods)
        {
            foreach ($pod in $pods)
            {
                $GetPod = Get-DatastoreCluster -Id $pod.ParentFolderId
                Write-Output $GetPod
            }
        }
        else
        {
            $datastores = Get-Cluster $Cluster | Get-Datastore
            foreach ($datastore in $datastores)
            {
                $ds = $datastore
                Write-Output $ds
            }
        }
    }
    end {}
}