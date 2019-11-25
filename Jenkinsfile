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

sed -i \'/resolver/d\' /home/sysmgr/Data/nfs/icis_elkn_stack/nginx/conf/default.conf

rm /home/sysmgr/Data/nfs/icis_elkn_stack/nginx/conf/nginx.conf'''
        sh '''echo Deploy

pwd

kubectl delete -f icis-elkn-es_deployment_staging.yaml
kubectl delete -f icis-elkn-kibana_deployment_staging.yaml
kubectl delete -f icis-elkn-logstash_deployment_staging.yaml
kubectl delete -f icis-elkn-nginx_deployment_staging.yaml

sleep 5

kubectl apply -f icis-elkn-es_deployment_staging.yaml

sleep 10

kubectl apply -f icis-elkn-kibana_deployment_staging.yaml
kubectl apply -f icis-elkn-logstash_deployment_staging.yaml
kubectl apply -f icis-elkn-nginx_deployment_staging.yaml'''
      }
    }
  }
}