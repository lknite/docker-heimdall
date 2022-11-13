pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: docker
            image: docker:dind
            tty: true
            securityContext:
              privileged: true
            resources:
              limits:
                memory: 512m
                cpu: 512Mi
        '''
    }
  }
  stages {
    stage('Git clone') {
      steps {
        git branch: 'master', credentialsId: 'github-lknite',
          url: 'https://github.com/lknite/docker-heimdall.git'
      }
    }
    stage('Build container') {
      steps {
        container('docker') {
          sh 'docker version'
          withCredentials([file(credentialsId: 'ca-bundle-pem-format', variable: 'CABUNDLE')]) {
            sh "cp \"\$CABUNDLE\" /etc/ssl/certs/ca-bundle.crt"
          }
          sh 'docker logout harbor.vc-prod.k.home.net'
          withCredentials([file(credentialsId: 'docker-config', variable: 'DOCKERCONFIG')]) {
            sh "cp \"\$DOCKERCONFIG\" \$HOME/.docker/config.json"
          }
          sh 'docker build --network host -t "harbor.vc-prod.k.home.net/library/docker-heimdall:0.0.${BUILD_NUMBER}" .'
          sh 'docker image push "harbor.vc-prod.k.home.net/library/docker-heimdall:0.0.${BUILD_NUMBER}"'
          sh 'docker build --network host -t "harbor.vc-prod.k.home.net/library/docker-heimdall:latest" .'
          sh 'docker image push "harbor.vc-prod.k.home.net/library/docker-heimdall:latest"'
        }
      }
    }
  }
}
