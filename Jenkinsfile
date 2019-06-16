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
    image: gcr.io/spaterson-project/jenkins-ruby-tf-aws-inspec:build
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
                sh 'pwd'
                sh 'ls -al'
                sh 'echo PATH is: $PATH'
                sh 'git --version'
                sh 'wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz'
                sh 'tar -C /usr/local -xzf go1.12.6.linux-amd64.tar.gz'
                sh 'export PATH=$PATH:/usr/local/go/bin'
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
