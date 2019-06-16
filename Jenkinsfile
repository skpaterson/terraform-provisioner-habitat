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
                sh 'chmod +x ./build.sh'
                dir ('/home/jenkins/workspace/TF-Hab-Provisioner_master') { 
                  sh('bash build.sh')
                }  
              }
            }
    }
    stage('Test TF Habitat Provisioner') {
        steps {
            container('habprov') {
                sh 'go version'
                sh 'terraform --version'
            }
        }
    }
  }
  triggers {
    cron 'H 10 * * *'
  }
  
  options {
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '10')
  }
}
