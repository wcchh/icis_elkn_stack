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
* Kibana:
    * 外網: http://goodtiming.wiicoo.co/kibana
    * 內網: http://192.168.23.69/kibana

## 服務代理

* ES查詢服務(only guo index): http://goodtiming.wiicoo.co/essearch
```
 /essearch ==> http://elasticsearch:9200/guo/_search
```
* ES查詢服務(only ptt index): http://goodtiming.wiicoo.co/pttsearch
```
 /pttsearch ==> http://elasticsearch:9200/ptt/_search
```
* Google Trend CSV API: http://goodtiming.wiicoo.co/gtacsv
```
 /gtacsv ==> http://gta_srv:8080/
```
* Google News: http://goodtiming.wiicoo.co/gnews/關鍵字
```
 /gnews/關鍵字 ==> https://news.google.com/rss/search?q=關鍵字&hl=zh-TW&gl=TW&ceid=TW:zh-Hant
 主要給logstash使用，原始網址logstash會出錯
```
* Kibana : http://goodtiming.wiicoo.co/kibana
```
 /kibana ==> http://kibana:5601/
``` 
-->
## Stand Alone Volumes

Using command: `$ docker volume ls` and we could see them:

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

