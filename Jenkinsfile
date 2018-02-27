pipeline {
	agent any
    environment {
        vcenter_cred = credentials('02ce81e7-6ab7-4c43-bc82-6104fe08b769')
    }
    parameters {
        string(name: 'vcenter_server', defaultValue: 'vcenter.ad.piccola.us', description: 'The vCenter server to use.')
        string(name: 'vm_1', defaultValue: 'nuget', description: 'vm_1 to get')
        string(name: 'vm_2', defaultValue: 'app', description: 'vm_2 to get')
    }    
	stages {
		stage('stage #1') {
			steps {
                powershell returnStatus: true, script: '''
                    Get-Module -ListAvailable VMware* | Import-Module | Out-Null
                    Connect-VIServer -Server $env:vcenter_server -User $env:vcenter_cred_USR -Password $env:vcenter_cred_PSW
                    $vm = Get-VM $env:vm_1
                    Write-Output $vm.name
                    Disconnect-VIServer -Force -Server $env:vcenter_server -Confirm:$false
                '''
			}
		}
		stage('stage #2') {
			steps {
				powershell returnStatus: true, script: '.\\Get-VM.ps1 -usr $env:vcenter_cred_USR -psw $env:vcenter_cred_PSW -vmname $env:vm_2 -vcenter $env:vcenter_server'
			}
		}
        stage('stage #3') {
            parallel {
                stage('stage #3.1') {
                    steps {
                        powershell 'sleep 1'
                    }
                }
                stage('stage #3.2') {
                    steps {
                        powershell 'sleep 2'
                    }
                }
            }
        }
	}
    post {
        failure {
            powershell 'write-output "this runs on fail"'
        }
        always {
            powershell 'write-output "this runs always"'
        }
    }
}