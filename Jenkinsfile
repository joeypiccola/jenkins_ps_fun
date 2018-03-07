pipeline {
	agent any
    environment {
        cred_vcenter_adpiccolaus = credentials('02ce81e7-6ab7-4c43-bc82-6104fe08b769')
        cred_ad_adpiccolaus = credentials('5d000f2e-6b25-42cf-8b6c-a25d03ea1827')
        cred_ad_ciscom = credentials('f81564bb-2c87-475e-b7ae-ae3d9efbc79b')
        cred_workgroup = credentials('70a5a300-d45d-4034-93c6-292d1b038285')
    }
    options {
        timeout(time: 1, unit: 'HOURS')
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
        stage('get build data') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1
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
        stage('get template') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\Get-Template.ps1
                '''
            }
        }        
        stage('new ADComputer') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\New-ADComputer.ps1
                '''
            }
        }
        stage('new OSCustomizationSpec') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\New-OSCustomizationSpec.ps1
                '''
            }
        }
        stage('new VM') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\New-VM.ps1
                '''
            }
        }
        stage('remove OSCustomizationSpec') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\Remove-OSCustomizationSpec.ps1
                '''
            }
        }
        stage('set VM') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\Set-VM.ps1
                '''
            }
        }
        stage('start VM') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\Start-VM.ps1
                '''
            }
        }    
        stage('get VM DHCP') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\Get-VMIP.ps1 -Stage DHCP
                '''
            }
        }
        stage('get VM Static') {
            steps {
                powershell '''
                    .\\Get-BuildData.ps1 | .\\Get-VMIP.ps1 -Stage static
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