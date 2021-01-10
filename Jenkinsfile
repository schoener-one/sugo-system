pipeline {
  agent {
    docker {
      image 'crops/poky:ubuntu-18.04'
      args '--rm -it -v /home/jenkins/yocto/cache:/var/cache/yocto'
    }

  }
  stages {
    stage('yocto-build') {
      steps {
        git(url: 'git clone git@bitbucket.org:schoenerone/moco-system.git', branch: 'master')
        sh 'ls -lh .'
      }
    }

  }
  environment {
    DL_DIR = '/var/cache/yocto/downloads'
    SSTATE_DIR = '/var/cache/yocto/sstate'
  }
}