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

    }    
	stages {
        stage('prerequisite checks') {
            steps {
                powershell '''
                    .\\Get-Credentials.ps1 | .\\Show-Credentials.ps1
                '''
            }
        }
        stage('stage ad computer') {
            steps {
                powershell '''
                    #$params = @{
                    #    adjoin_user  = $env:adjoin_user
                    #    adjoin_pass  = $env:adjoin_pass
                    #    vmname       = $env:vmname
                    #    win_domain   = $env:win_domain
                    #}
                    #.\\New-ADComputer.ps1 @params
                '''
            }
        }        
	}
}