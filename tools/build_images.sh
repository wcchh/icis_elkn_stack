#!/bin/bash
# Tag and push to 
REGSERVER="docker.justup.co"
PRJNAME="guoelection"

if [ -n "$PRJNAME" ]; then
	PRJNAME="$PRJNAME"_
fi

cd ..

# echo "Build base image"
docker tag "$PRJNAME"elasticsearch:latest $REGSERVER/"$PRJNAME"elasticsearch:latest
docker tag "$PRJNAME"kibana:latest        $REGSERVER/"$PRJNAME"kibana:latest
docker tag "$PRJNAME"logstash:latest      $REGSERVER/"$PRJNAME"logstash:latest
docker tag "$PRJNAME"nginx:latest         $REGSERVER/"$PRJNAME"nginx:latest

# echo "Push base image"
docker push $REGSERVER/"$PRJNAME"elasticsearch:latest
docker push $REGSERVER/"$PRJNAME"kibana:latest
docker push $REGSERVER/"$PRJNAME"logstash:latest
docker push $REGSERVER/"$PRJNAME"nginx:latest
