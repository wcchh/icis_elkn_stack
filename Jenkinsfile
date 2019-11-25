pipeline {
  agent any
  stages {
    stage('Production Sync Code') {
      steps {
        sh 'rsync -avh * /home/sysmgr/Data/nfs/icis_elkn_stack'
      }
    }
    stage('Production Deploy') {
      steps {
        git 'git@192.168.23.68:semiconductor_bigdata/b_group/icis_elkn_stack.git'
        sh 'pwd'
      }
    }
  }
}