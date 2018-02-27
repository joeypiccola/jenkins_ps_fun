pipeline {
	agent any
    environment {
        vcenter_cred = credentials('02ce81e7-6ab7-4c43-bc82-6104fe08b769')
    }
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
    }    
	stages {
		stage('stage #1') {
			steps {
                powershell '''
                    Get-Module -ListAvailable VMware* | Import-Module | Out-Null
                    Connect-VIServer -Server vcenter -User $env:vcenter_cred_USR -Password $env:vcenter_cred_PWD
                    $vm = Get-VM app
                    Write-Output $vm.name
                    Disconnect-VIServer -Force -Server vcenter -Confirm:$false
                '''
			}
		}
		stage('stage #2') {
			steps {
				powershell 'write-output 1'
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
}