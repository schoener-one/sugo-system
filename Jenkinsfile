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

    stage('archive-artifacts') {
      steps {
        echo 'Archive artifacts'
        archiveArtifacts(artifacts: 'build/tmp/deploy/images/raspberrypi3/core-image-base-moco-raspberrypi3.rpi-sdimg', followSymlinks: true, onlyIfSuccessful: true)
        archiveArtifacts(artifacts: 'build/tmp/deploy/sdk/poky-*.sh', followSymlinks: true, onlyIfSuccessful: true)
      }
    }

  }
  environment {
    DL_DIR = '/var/cache/yocto/downloads'
    SSTATE_DIR = '/var/cache/yocto/sstate'
  }
}