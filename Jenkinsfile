pipeline {
	agent any
    environment {
        vcenter_cred_adpiccolaus = credentials('02ce81e7-6ab7-4c43-bc82-6104fe08b769')
        if ("ad.piccola.us".equals(win_domain)) {
            def vcenter_user = vcenter_cred_adpiccolaus_USR
            return vcenter_user
        }
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
		stage('prerequisites checks') {
			steps {
                powershell '''
                    write-output "$env:vcenter_user"
                '''
			}
		}
	}
    post {
        failure {
            powershell 'write-output "this runs on fail"'
        }
        always {
            powershell 'write-output "this runs always"'
        }
    }
}