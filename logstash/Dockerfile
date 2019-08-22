FROM docker.elastic.co/logstash/logstash-oss:6.7.2

USER root

RUN yum -y install centos-release-scl
# RUN yum install -y wget
RUN yum -y install deltarpm
RUN yum -y install rh-python36
RUN yum -y install epel-release
RUN yum -y install python-pip
RUN pip install --upgrade pip

RUN /opt/rh/rh-python36/root/usr/bin/pip3 install twnews
RUN /opt/rh/rh-python36/root/usr/bin/pip3 install elasticsearch

RUN bin/logstash-plugin install logstash-input-rss
RUN bin/logstash-plugin install logstash-output-exec
RUN bin/logstash-plugin update logstash-input-file

RUN mkdir -p /usr/share/logstash/data/file_input_sincedb

ADD pipeline /usr/share/logstash/pipeline
ADD config /usr/share/logstash/config
ADD script /usr/share/logstash/script
ADD patterns /usr/share/logstash/patterns

# 移除預設的pipeline conf
RUN rm /usr/share/logstash/pipeline/logstash.conf

# 更新新聞擷取設定檔
ADD twnews/conf/news-soup.json /opt/rh/rh-python36/root/usr/lib/python3.6/site-packages/twnews/conf/news-soup.json

USER logstash
