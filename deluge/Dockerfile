FROM archlinux/base

ADD install.sh /
RUN /install.sh && rm -f /install.sh

RUN useradd -m -s /bin/sh user && \
    passwd -d user

VOLUME /config /data
EXPOSE 8112 58846

ADD services.ini /etc/supervisor.d/
ADD my_init /
CMD ["/my_init"]
