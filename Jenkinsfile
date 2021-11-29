pipeline {
  agent {
    node {
      label 'DOCKER'
    }

  }
  stages {
    stage('Build system image') {
      steps {
        echo 'Build system image'
        sh '''docker run --rm -t \\
--network host \\
-v $PWD:/workdir \\
-v $HOME/yocto/cache:/var/cache/yocto \\
-v $HOME/.ssh:/home/pokyuser/.ssh:ro \\
--env DL_DIR \\
--env SSTATE_DIR \\
crops/poky:ubuntu-18.04 \\
--workdir=/workdir \\
./build.sh -b'''
      }
    }

    stage('Build system SDK') {
      steps {
        echo 'Build system SDK'
        sh '''docker run --rm -t \\
--network host \\
-v $PWD:/workdir \\
-v $HOME/yocto/cache:/var/cache/yocto \\
-v $HOME/.ssh:/home/pokyuser/.ssh:ro \\
--env DL_DIR \\
--env SSTATE_DIR \\
crops/poky:ubuntu-18.04 \\
--workdir=/workdir \\
./build.sh -s'''
      }
    }

    stage('Pack up artifacts') {
      steps {
        echo 'Pack up artifacts'
        sh '''./build.sh -p ${BUILD_NUMBER} \\
-i "build/tmp/deploy/images/raspberrypi-cm3/core-image-base-sugo-raspberrypi-cm3.wic.bz2" \\
-f "build/tmp/deploy/sdk/poky-glibc-x86_64-core-image-base-sugo-*.sh"'''
      }
    }

    stage('Archive artifacts') {
      steps {
        echo 'Archive built artifacts'
        archiveArtifacts(artifacts: 'sugo-system*.tar.gz', onlyIfSuccessful: true, caseSensitive: true)
      }
    }

  }
  environment {
    DL_DIR = '/var/cache/yocto/downloads'
    SSTATE_DIR = '/var/cache/yocto/sugo/sstate'
  }
}
