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
  def root = tool name: 'Go 1.9', type: 'go'

  stages {
    stage('Build Information') {
        steps {
            container('habprov') {
                sh 'ls -al'
                sh 'pwd'
                sh 'echo $PATH'
                sh 'git --version'
                sh 'terraform --version'
                // Install the desired Go version
  
                // Export environment variables pointing to the directory where Go was installed
                withEnv(["GOROOT=${root}", "PATH+GO=${root}/bin"]) {
                  sh 'go version'
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
