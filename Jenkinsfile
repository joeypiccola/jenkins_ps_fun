pipeline {
	agent any
    options {
        timeout(time: 20, unit: 'MINUTES')
    }
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
    }    
	stages {
		stage('stage #1') {
			steps {
				powershell 'get-Childitem'
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
                        powershell 'sleep 10'
                    }
                }
                stage('stage #3.2') {
                    steps {
                        powershell 'sleep 20'
                    }
                }
            }
        }
	}
}