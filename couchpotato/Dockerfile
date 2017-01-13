FROM alpine

RUN apk add --no-cache git python py2-lxml py2-openssl shadow unrar supervisor && \
    git clone --depth 1 https://github.com/CouchPotato/CouchPotatoServer.git /CouchPotatoServer

RUN adduser -D -s /bin/sh user && \
    passwd -d user

VOLUME /config /data
EXPOSE 5050

ADD services.ini /etc/supervisor.d/
ADD my_init /
CMD ["/my_init"]
