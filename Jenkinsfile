node {
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
    }
        
    stage ('clone') {
        git branch: 'test', changelog: false, poll: false, url: 'https://github.com/joeypiccola/control-repo.git'
    }
    withCredentials([usernamePassword(credentialsId: '02ce81e7-6ab7-4c43-bc82-6104fe08b769', passwordVariable: 'vcenterpass', usernameVariable: 'vcenteruser')]) {
        stage ('Get-VM #1') {
            powershell '''
                Get-Module -ListAvailable VMware* | Import-Module | Out-Null
                Connect-VIServer -Server 'vcenter.ad.piccola.us' -User $($env:vcenteruser) -Password $($env:vcenterpass)
                $vm = Get-VM 'app'
                Write-Output $vm.name
                Disconnect-VIServer -Force -Server 'vcenter.ad.piccola.us' -Confirm:$false
            '''
        }
        stage ('Get-VM #2') {
                env.getvm = powershell(returnStdout: true, script: '''
                $blah = Get-Module -ListAvailable VMware* | Import-Module
                $blah = Connect-VIServer -Server 'vcenter.ad.piccola.us' -User $($env:vcenteruser) -Password $($env:vcenterpass)
                $vm = Get-VM 'nuget'
                Write-Output "The server name is $($vm.name)"
                $blah = Disconnect-VIServer -Force -Server 'vcenter.ad.piccola.us' -Confirm:$false
            ''')
        }
        stage ('show me what you got') {
            echo "getvm is ${env.getvm}"
            powershell '''
                write-output "powershell says: $($env:getvm)"
            '''                  
        }
    }    
}