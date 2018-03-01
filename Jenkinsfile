pipeline {
	agent any
    environment {
        cred_vcenter_adpiccolaus = credentials('02ce81e7-6ab7-4c43-bc82-6104fe08b769')
        cred_ad_adpiccolaus = credentials('5d000f2e-6b25-42cf-8b6c-a25d03ea1827')
        cred_ad_ciscom = credentials('f81564bb-2c87-475e-b7ae-ae3d9efbc79b')
    }
    parameters {
        string(name: 'vmname')
        string(name: 'vcenter')
        string(name: 'datacenter')
        string(name: 'cluster')
        string(name: 'datastore')
        string(name: 'portgroup')
        string(name: 'ip')
        string(name: 'gateway')
        string(name: 'netmask')
        string(name: 'dns_p')
        string(name: 'dns_s')
        string(name: 'dns_t')
        string(name: 'win_domain')
        string(name: 'disk_1')
        string(name: 'disk_2')
        string(name: 'disk_3')
        string(name: 'disk_4')
        string(name: 'disk_5')

    }
	stages {
        stage('prerequisite checks') {
            steps {
                powershell '''
                    . .\\helperFunctions.ps1
                    .\\Get-EnvData.ps1 | .\\Invoke-PrerequsitesChecks.ps1
                '''
            }
        }
        stage('stage ADComputer') {
            steps {
                powershell '''
                    . .\\helperFunctions.ps1
                    .\\Get-EnvData.ps1 | .\\New-ADComputer.ps1
                '''
            }
        }
        stage('stage OSCustomizationSpec') {
            steps {
                powershell '''
                    . .\\helperFunctions.ps1
                    .\\Get-EnvData.ps1 | .\\New-OSCustomizationSpec.ps1
                '''
            }
        }
	}
}