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
        string(name: 'vmname', description '')
        string(name: 'vcenter', description '')
        string(name: 'datacenter', description '')
        string(name: 'cluster', description '')
        string(name: 'datastore', description '')
        string(name: 'portgroup', description '')
        string(name: 'ip', description '')
        string(name: 'gateway', description '')
        string(name: 'netmask', description '')
        string(name: 'dns_p', description '')
        string(name: 'dns_s', description '')
        string(name: 'dns_t', description '')
        string(name: 'win_domain', description '')
        
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