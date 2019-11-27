pipeline {
  agent any
  stages {
    stage('Production Sync Code') {
      steps {
        sh '''sed -i \'3d\' /home/sysmgr/Data/nfs/icis_elkn_stack/logstash/pipeline/nginx.conf

cat /home/sysmgr/Data/nfs/icis_elkn_stack/logstash/pipeline/nginx.conf

sed -i \'s/kibana:5601/192.168.22.200:30008/g\' /home/sysmgr/Data/nfs/icis_elkn_stack/nginx/conf/default.conf

sed -i \'/resolver/d\' /home/sysmgr/Data/nfs/icis_elkn_stack/nginx/conf/default.conf

rm /home/sysmgr/Data/nfs/icis_elkn_stack/nginx/conf/nginx.conf

rsync -avh * /home/sysmgr/Data/nfs/icis_elkn_stack'''
      }
    }
    stage('Production Deploy') {
      steps {
        sh '''echo Deploy

pwd

kubectl delete -f /home/sysmgr/k8s-production/icis/icis-elkn-es_deployment_staging.yaml
kubectl delete -f /home/sysmgr/k8s-production/icis/icis-elkn-kibana_deployment_staging.yaml
kubectl delete -f /home/sysmgr/k8s-production/icis/icis-elkn-logstash_deployment_staging.yaml
kubectl delete -f /home/sysmgr/k8s-production/icis/icis-elkn-nginx_deployment_staging.yaml

sleep 5

kubectl apply -f /home/sysmgr/k8s-production/icis/icis-elkn-es_deployment_staging.yaml

sleep 10

kubectl apply -f /home/sysmgr/k8s-production/icis/icis-elkn-kibana_deployment_staging.yaml
kubectl apply -f /home/sysmgr/k8s-production/icis/icis-elkn-logstash_deployment_staging.yaml
kubectl apply -f /home/sysmgr/k8s-production/icis/icis-elkn-nginx_deployment_staging.yaml'''
      }
    }
  }
}