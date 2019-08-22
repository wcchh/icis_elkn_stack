FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.7.2
ENV VERSION=6.7.2

# 不顯示deprecation警告層級訊息
RUN echo "logger.deprecation.name = org.elasticsearch.deprecation" >> config/log4j2.properties
RUN echo "logger.deprecation.level = error" >> config/log4j2.properties

# 安裝ik中文分詞器
# RUN sh -c '/bin/echo -e "y" | ./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v${VERSION}/elasticsearch-analysis-ik-$VERSION.zip'
ADD ./plugin/elasticsearch-analysis-ik-${VERSION}.zip /tmp/elasticsearch-analysis-ik-${VERSION}.zip
RUN sh -c '/bin/echo -e "y" | ./bin/elasticsearch-plugin install file:///tmp/elasticsearch-analysis-ik-${VERSION}.zip'

RUN rm /tmp/elasticsearch-analysis-ik-${VERSION}.zip

ADD config/analysis-ik/IKAnalyzer.cfg.xml /usr/share/elasticsearch/config/analysis-ik/IKAnalyzer.cfg.xml
ADD config/analysis-ik/user.dic /usr/share/elasticsearch/config/analysis-ik/user.dic
ADD config/analysis-ik/stopwords.dic /usr/share/elasticsearch/config/analysis-ik/stopwords.dic