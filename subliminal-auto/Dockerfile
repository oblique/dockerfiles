FROM alpine

RUN apk add --no-cache python3 ca-certificates && \
    pip3 --no-cache-dir install subliminal watchdog

ADD subliminal_watchdog.py /
CMD /subliminal_watchdog.py
