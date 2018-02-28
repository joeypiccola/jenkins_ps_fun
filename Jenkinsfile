pipeline {
	agent any
    environment {
        vcenter_cred_adpiccolaus = credentials('02ce81e7-6ab7-4c43-bc82-6104fe08b769')
        vcenter_cred_testcom = credentials('f89cc8d0-b680-417e-bb4c-4aadf3d64c43')
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
		stage('credential mapping') {
			steps {
                script {
                    if (env.win_domain == 'ad.piccola.us') {
                        env.vcenter_user = vcenter_cred_adpiccolaus_USR
                        env.vcenter_pass = vcenter_cred_adpiccolaus_PSW
                    }
                    if (env.win_domain == 'test.com') {
                        env.vcenter_user = vcenter_cred_testcom_USR
                        env.vcenter_pass = vcenter_cred_testcom_PSW
                    }
                }
			}
		}
        stage('prerequisite checks') {
            steps {
                powershell '''
                    powershell '.\\Get-VM.ps1 -usr $env:vcenter_user -psw $env:vcenter_pass -vmname nuget -vcenter $env:vcenter'
                '''
            }
        }
	}
}