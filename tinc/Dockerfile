FROM alpine

RUN apk add --no-cache tini tinc

VOLUME /etc/tinc

ADD my_init /
ENTRYPOINT ["tini", "--"]
CMD ["/my_init"]
