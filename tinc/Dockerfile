FROM alpine

RUN apk add --no-cache tini tinc

EXPOSE 655/tcp 655/udp
VOLUME /etc/tinc

ENTRYPOINT ["tini", "--"]
CMD ["tincd", "-D"]
