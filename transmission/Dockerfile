FROM alpine

RUN apk add --no-cache transmission-daemon

RUN adduser -D -s /bin/sh user
USER user

VOLUME ['/config' '/downloads' '/incomplete' '/watch']
EXPOSE 9091

ADD my_init /
CMD '/my_init'
