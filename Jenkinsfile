pipeline {
	agent none

	stages {
		stage (Get-VM #1) {
			steps {
				powershell 'Write-Host red'
				powershell 'Write-Host green'
			}
		}
		stage (Get-VM #2) {
			steps {
				powershell 'Write-Host red'
				powershell 'Write-Host green'
			}
		}
	}
}