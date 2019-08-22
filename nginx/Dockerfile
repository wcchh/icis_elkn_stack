FROM nginx:latest
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf
ADD ./src/frontend  /usr/share/nginx/html
COPY ./etc/nginx/.htpasswd /etc/nginx/.htpasswd