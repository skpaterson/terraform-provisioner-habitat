def pod_label = "habprov-tf-${UUID.randomUUID().toString()}"
pipeline {
  agent {
    kubernetes {
      label pod_label
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: habprov
    image: gcr.io/spaterson-project/habprovtest1:latest
    command: ['cat']
    tty: true
    alwaysPullImage: true
"""
    }
  }
  stages {
    stage('Build Information') {
        steps {
            container('habprov') {
                sh 'pwd'
                sh 'ls -al'
                sh 'echo PATH = $PATH'
                sh 'which go'
                sh 'go version'
//                sh 'chmod +x ./build.sh'
//                sh 'chmod +x ./test.sh'
          }
        }
      }
  }
  triggers {
    cron 'H 10 * * *'
  }
  post {
    success {
        slackSend color: 'good', message: "The pipeline ${currentBuild.fullDisplayName} completed successfully. <${env.BUILD_URL}|Details here>."
    }
    failure {
        slackSend color: 'danger', message: "Pipeline failure ${currentBuild.fullDisplayName}. Please <${env.BUILD_URL}|resolve issues here>."
    }
  }
  options {
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '10')
  }
}
