FROM alpine

ADD install.sh /
RUN /install.sh && rm -f /install.sh
ENV DOCKER_HOST "unix:///tmp/docker.sock"

VOLUME /certs

ADD route53_hook.sh /opt
ADD renew_certs /usr/local/bin

ADD entrypoint.sh my_init /
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
CMD ["/my_init"]
