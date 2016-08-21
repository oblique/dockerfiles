FROM alpine

RUN apk add --no-cache git python py-pip py-lxml openssl libffi \
        gcc python-dev musl-dev openssl-dev libffi-dev && \
    pip --no-cache-dir install --upgrade pyopenssl && \
    git clone --depth 1 https://github.com/RuudBurger/CouchPotatoServer.git /CouchPotatoServer && \
    apk del gcc python-dev musl-dev openssl-dev libffi-dev

RUN adduser -D -s /bin/sh user
USER user

VOLUME /config /data
EXPOSE 5050

ADD my_init /
CMD '/my_init'
