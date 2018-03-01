pipeline {
	agent any
    environment {
        cred_adpiccolaus_vcenter = credentials('02ce81e7-6ab7-4c43-bc82-6104fe08b769')
        cred_adpiccolaus_adjoin = credentials('5d000f2e-6b25-42cf-8b6c-a25d03ea1827')
        cred_adpiccolaus_vcenter = credentials('02ce81e7-6ab7-4c43-bc82-6104fe08b769')
        cred_adpiccolaus_adjoin = credentials('5d000f2e-6b25-42cf-8b6c-a25d03ea1827')
        blah = 'woot'
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
                        env.adjoin_user = cred_adpiccolaus_adjoin_USR
                        env.adjoin_pass = cred_adpiccolaus_adjoin_PSW
                    }
                    if (env.win_domain == 'cis.com') {
                        env.adjoin_user = cred_adpiccolaus_adjoin_USR
                        env.adjoin_pass = cred_adpiccolaus_adjoin_PSW
                    }                    
                    if (env.vcenter == 'vcenter.ad.piccola.us') {
                        env.vcenter_user = cred_adpiccolaus_vcenter_USR
                        env.vcenter_pass = cred_adpiccolaus_vcenter_PSW
                    }
                }
			}
		}
        stage('prerequisite checks') {
            steps {
                powershell '''
                    $params = @{
                        vcenter_user = $env:vcenter_user
                        vcenter_pass = $env:vcenter_pass
                        adjoin_user  = $env:adjoin_user
                        adjoin_pass  = $env:adjoin_pass
                        vcenter      = $env:vcenter
                        vmname       = $env:vmname
                        win_domain   = $env:win_domain
                    }
                    .\\Invoke-PrerequsitesChecks.ps1 @params
                '''
            }
        }
        stage('stage ad computer') {
            steps {
                powershell '''
                    $params = @{
                        adjoin_user  = $env:adjoin_user
                        adjoin_pass  = $env:adjoin_pass
                        vmname       = $env:vmname
                        win_domain   = $env:win_domain
                    }
                    .\\New-ADComputer.ps1 @params
                '''
            }
        }        
	}
}