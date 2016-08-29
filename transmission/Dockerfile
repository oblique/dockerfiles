FROM alpine:edge

RUN apk add --no-cache transmission-daemon e2fsprogs-extra shadow && \
    adduser -D -s /bin/sh user && \
    passwd -d user

VOLUME /config /data
EXPOSE 9091

ADD my_init start /
CMD /my_init
