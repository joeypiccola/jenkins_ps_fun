pipeline {
	agent any

	stages {
		stage ('Get-VM #1') {
			steps {
				powershell 'get-Childitem'
			}
		}
		stage ('Get-VM #2') {
			steps {
				powershell 'write-output 1'
			}
		}
	}
}