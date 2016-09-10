FROM nginx:stable

ADD default.conf /etc/nginx/conf.d

EXPOSE 80 443
VOLUME /usr/share/nginx/html

ADD my_init /
CMD ["/my_init"]
