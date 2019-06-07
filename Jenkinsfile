def pod_label = "habprov-cmdb-${UUID.randomUUID().toString()}"
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
    image: gcr.io/spaterson-project/jenkins-habprov:latest
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
                sh 'ls -al'
                sh 'pwd'
                sh 'echo $PATH'
                sh 'git --version'
                sh 'go version'
            }
        }
    }
    stage('Test TF Habitat Provisioner') {
        steps {
            container('habprov') {
                sh 'habprov run pwd'
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
