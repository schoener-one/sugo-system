pipeline {
  agent {
    docker {
      image 'crops/poky:ubuntu-18.04'
      args '-v /home/jenkins/yocto/cache:/var/cache/yocto'
    }

  }
  stages {
    stage('yocto-build') {
      steps {
        echo 'Starting Yocto build'
        sh '''echo "DL_DIR=$DL_DIR"
echo "SSTATE_DIR=$SSTATE_DIR"
./build.sh'''
      }
    }

  }
  environment {
    DL_DIR = '/var/cache/yocto/downloads'
    SSTATE_DIR = '/var/cache/yocto/sstate'
  }
}