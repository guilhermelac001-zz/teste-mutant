pipeline {

    agent {
        kubernetes {
            containerTemplate {
                name 'devops-toolbox'
                image 'gcr.io/emb-infra/devops-toolbox:latest'
                ttyEnabled true
                command 'cat'
            }
        }
    }

    parameters {
        string(name: 'GCP_PROJECT_ID', defaultValue: '', description: 'GCP Project that contains GKE Cluster')
        string(name: 'CLUSTER_NAME', defaultValue: '', description: 'GKE Cluster Name')
        credentials(credentialType: 'com.cloudbees.plugins.credentials.CredentialsParameterDefinition', name: 'GCP_KEY_NAME', required: true, description: 'Credential name loaded on Jenkins')
    }

    stages {
        stage('Jenkins - Basic Install') {
            steps {
                script {
                    def gkeEnv = load 'k8s/Jenkinsfile'
                    gkeEnv.settingUpGoogleKubernetesEnvironment(params.GCP_PROJECT_ID, params.CLUSTER_NAME, params.GCP_KEY_NAME)
                }

                sh """
                    ./k8s/apps/jenkins/install_jenkins_gke.sh
                """
            }
        }

    }
}