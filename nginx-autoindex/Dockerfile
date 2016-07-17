FROM nginx:stable

ADD my_init /
ADD default.conf /etc/nginx/conf.d

EXPOSE 80 443
VOLUME /usr/share/nginx/html

CMD '/my_init'
