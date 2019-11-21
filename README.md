# Intelligence Service

## 新聞資料來源
*  Google News: https://news.google.com
    * 透過RSS格式取得; Specify keyword by {XXX}, ex:郭台銘 | 劉揚偉
    * https://news.google.com/rss/search?q={XXX}&hl=zh-TW&gl=TW&ceid=TW:zh-Hant

*  Google Alerts: https://www.google.com.tw/alerts
<!-- *  Ptt：
    * 八卦版 Gossiping
    * 政黑版 HatePolitics -->

## 網址資訊

* 內網: http://192.168.22.3/
    * port: 8080, 5601, 9200, 5000
<!-- 
* 外網: http://goodtiming.wiicoo.co/
    * port: 80
-->
* Kibana:
<!-- 
    * 外網: http://goodtiming.wiicoo.co/kibana
-->
    * 內網: http://192.168.22.3:8080/kibana

## 服務代理(test yet)

* ES查詢服務(test yet): http://192.168.22.3:8080/essearch/dxi/_search
```
 /essearch ==> http://elasticsearch:9200/dxi/_search 
```

## Stand Alone Volumes

Using command: `$ docker volume ls | grep icis` and we could see them:

```
DRIVER    VOLUME NAME
local            icis_esdata
local            icis_lsdata
```

## Issues
As run up elasticsearch service, we may have this error : 
```
"Unable to receive connection: http://elasticsearch:9200/"
vm.max_map_count on the linux box kernel setting needs to be set to at least 262144
```

And we could fix it from host by 
`$ sudo sysctl -w vm.max_map_count=262144`

## Deployment
### Deploy to development host (22.3)
Go the "tools" folder under project, and execute below command:

`icis_elkn_stack/tools $ sh deploy_remote.sh`

With default environment settings (as below), it will deploy current project to 22.3 host.
* REMOTE_ADDR="192.168.22.3" 
* REMOTE_ACC="jenkins" 
* R_BASEFOLDERNAME="icis" 

## Elasticsearch Cluster
There're two `yml` files for the different modes of elasticsearch:
* Cluster Mode: docker-compose-cluster.yml
* Single Mode: docker-compose-single.yml

Choose mode by copy the mode `yml` file to `docker-compose.yml`. (force cover currently file)

Current  cluster mode has 1 master and 2 data nodes.