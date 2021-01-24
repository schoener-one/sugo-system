pipeline {
  agent {
    node {
      label 'DOCKER'
    }

  }
  stages {
    stage('yocto-build') {
      steps {
        echo 'Starting Yocto build'
        sh 'docker run --rm -t -v $PWD:/workdir -v $HOME/yocto/cache:/var/cache/yocto --env DL_DIR --env SSTATE_DIR crops/poky:ubuntu-18.04 --workdir=/workdir ls -lh'
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