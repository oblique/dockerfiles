FROM alpine:edge

RUN apk add --no-cache git python py2-pip py-lxml openssl libffi \
        gcc python-dev musl-dev openssl-dev libffi-dev shadow unrar && \
    pip --no-cache-dir install --upgrade pyopenssl && \
    git clone --depth 1 https://github.com/RuudBurger/CouchPotatoServer.git /CouchPotatoServer && \
    apk del gcc python-dev musl-dev openssl-dev libffi-dev

RUN adduser -D -s /bin/sh user && \
        passwd -d user

VOLUME /config /data
EXPOSE 5050

ADD my_init start /
CMD /my_init
