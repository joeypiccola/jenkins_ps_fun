node {
    stage ('clone') {
        git branch: 'test', changelog: false, poll: false, url: 'https://github.com/joeypiccola/control-repo.git'
    }
    withCredentials([usernamePassword(credentialsId: '02ce81e7-6ab7-4c43-bc82-6104fe08b769', passwordVariable: 'vcenterpass', usernameVariable: 'vcenteruser')]) {
        stage ('Get-VM') {
            powershell '''
                Get-Module -ListAvailable VMware* | Import-Module | Out-Null
                Connect-VIServer -Server 'vcenter.ad.piccola.us' -User $($env:vcenteruser) -Password $($env:vcenterpass) | out-null
                $vm = Get-VM 'app'
                Write-Output $vm.name
            '''
        }
    }    
}