FROM alpine

RUN apk add --no-cache python3 ca-certificates shadow supervisor && \
    pip3 --no-cache-dir install subliminal watchdog && \
    adduser -D user && \
    passwd -d user

ADD services.ini /etc/supervisor.d/
ADD subliminal_watchdog.py my_init /
CMD ["/my_init"]
