FROM alpine:edge

ADD install.sh /
RUN /install.sh && rm -f /install.sh

RUN adduser -D -s /bin/sh user && \
        passwd -d user

VOLUME /config /data
EXPOSE 6789

ADD my_init start /
CMD /my_init
