pipeline {
	agent any

	stages {
		stage ('Get-VM #1') {
			steps {
				powershell 'pwd'
			}
		}
		stage ('Get-VM #2') {
			steps {
				powershell 'cd c:\\'
				powershell 'pwd'
			}
		}
	}
}