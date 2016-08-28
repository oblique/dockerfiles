FROM alpine:edge

RUN apk add --no-cache python3 ca-certificates shadow && \
    pip3 --no-cache-dir install subliminal watchdog && \
    adduser -D user && \
    passwd -d user

ADD subliminal_watchdog.py my_init /
CMD /my_init
