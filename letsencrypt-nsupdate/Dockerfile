FROM alpine

ADD install.sh /
RUN /install.sh && rm -f /install.sh

VOLUME /config

ADD config /etc/dehydrated/config
ADD nsupdate_hook.sh /opt
ADD renew_certs /usr/local/bin

ADD my_init /
CMD ["/my_init"]
