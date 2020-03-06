def label = "worker-${UUID.randomUUID().toString()}"

// Environment Variables
String[] str;
str = job_name.split('/'); //Full Job Name
short_job_name = str[1].toLowerCase()
stack = str[0].toLowerCase()
env.PROJECT_ID = "mutantproject"

println short_job_name
println stack
println PROJECT_ID

podTemplate(label: label, containers: [
  containerTemplate(name: 'devops-toolbox', image: "gcr.io/${env.PROJECT_ID}/devops-toolbox:latest", command: 'cat', ttyEnabled: true,privileged: true, alwaysPullImage: true, resourceRequestMemory: '1024Mi', resourceLimitMemory: '1024Mi')
],
volumes: [
  //hostPathVolume(mountPath: '/home/gradle/.gradle', hostPath: '/tmp/jenkins/.gradle'),
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {

  node(label) {
    deleteDir()
    def myRepo = checkout scm
    def gitCommit = myRepo.GIT_COMMIT
    def gitBranch = myRepo.GIT_LOCAL_BRANCH
    def shortGitCommit = "${gitCommit[0..7]}"
      
    stage('Container Build') {
        container('devops-toolbox') {
            sh """
                  docker build -t ${short_job_name} .
                  docker tag ${short_job_name}:latest gcr.io/${env.PROJECT_ID}/${job_name}:${gitCommit}
            """
        }
    }
    
    stage('Container Registry Push') {
        container('devops-toolbox') {
          withCredentials([file(credentialsId: 'GOOGLE_SERVICE_ACCOUNT', variable: 'GC_KEY')]) {
            sh """gcloud auth activate-service-account --key-file ${GC_KEY};
                  gcloud auth configure-docker --quiet
                  docker push gcr.io/${env.PROJECT_ID}/${job_name}:${gitCommit}
            """
            }
        }
    }

    stage('Application Deploy') {
        container('devops-toolbox'){
            sh """cd ci
                  sed -i "s/latest/${gitCommit}/g" ${short_job_name}/${stack}-values.yaml
                  gcloud container clusters get-credentials ${stack} --zone us-central1-c --project ${env.PROJECT_ID}
                  helm upgrade --install ${short_job_name} --values ${short_job_name}/${stack}-values.yaml ${short_job_name} --debug
            """
        }
    }

  }
}