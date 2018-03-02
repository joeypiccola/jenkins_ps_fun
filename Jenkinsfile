pipeline {
	agent any
    environment {
        cred_vcenter_adpiccolaus = credentials('02ce81e7-6ab7-4c43-bc82-6104fe08b769')
        cred_ad_adpiccolaus = credentials('5d000f2e-6b25-42cf-8b6c-a25d03ea1827')
        cred_ad_ciscom = credentials('f81564bb-2c87-475e-b7ae-ae3d9efbc79b')
    }
    parameters {
        string(name: 'buildspec')
    }
	stages {
        stage('set build data') {
            steps {
                powershell '''
                    .\\Set-BuildData.ps1
                '''
            }
        }
        stage('prerequisite checks') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\Invoke-PrerequsitesChecks.ps1
                '''
            }
        }
        stage('stage ADComputer') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\New-ADComputer.ps1
                '''
            }
        }
        stage('stage OSCustomizationSpec') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\New-OSCustomizationSpec.ps1
                '''
            }
        }
	}
    post {
        always {
            cleanWs()
        }
    }
}