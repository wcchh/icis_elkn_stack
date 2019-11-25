pipeline {
  agent any
  stages {
    stage('Production Sync Code') {
      steps {
        sh '''sed -e \'3d\' /home/sysmgr/.jenkins-sa-k8s-master/workspace/icis-elkn_master/logstash/pipeline/nginx.conf
rsync -avh * /home/sysmgr/Data/nfs/icis_elkn_stack'''
      }
    }
    stage('Production Deploy') {
      steps {
        git 'git@192.168.23.68:semiconductor_bigdata/b_group/icis_elkn_stack.git'
        sh '''sed -e \'3d\' /home/sysmgr/Data/nfs/icis_elkn_stack/logstash/pipeline/nginx.conf

cat /home/sysmgr/Data/nfs/icis_elkn_stack/logstash/pipeline/nginx.conf

'''
      }
    }
  }
}