FROM archlinux/base

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S supervisor apache

VOLUME /data /config
EXPOSE 80 443

ADD httpd.conf /etc/httpd/conf/
ADD services.ini /etc/supervisor.d/
ADD my_init start_httpd /

CMD ["/my_init"]
