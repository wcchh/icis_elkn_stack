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
        sh '''sed -i \'3d\' /home/sysmgr/Data/nfs/icis_elkn_stack/logstash/pipeline/nginx.conf

cat /home/sysmgr/Data/nfs/icis_elkn_stack/logstash/pipeline/nginx.conf

sed -i \'s/kibana:5601/192.168.22.200:30008/g\' /home/sysmgr/Data/nfs/icis_elkn_stack/nginx/conf/default.conf

rm /home/sysmgr/Data/nfs/icis_elkn_stack/nginx/conf/nginx.conf'''
      }
    }
  }
}