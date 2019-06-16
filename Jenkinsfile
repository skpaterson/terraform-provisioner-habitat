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
    image: gcr.io/spaterson-project/jenkins-habprov:latest
    command: ['cat']
    tty: true
    securityContext:
      privileged: true
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
                sh 'python --version'
                sh 'wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz'
                }
            }
        }
    }
    stage('Test TF Habitat Provisioner') {
        steps {
            container('habprov') {
                sh 'go version'
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
