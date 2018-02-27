pipeline {
	agent any
    options {
        timeout(time: 20, unit: 'MINUTES')
    }
    environment {
        vcenter_cred = credential('02ce81e7-6ab7-4c43-bc82-6104fe08b769')
    }
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
    }    
	stages {
		stage('stage #1') {
			steps {
				powershell 'write-output $env:vcenter_cred_USR'
                powershell 'write-output $env:vcenter_cred_PSW'
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