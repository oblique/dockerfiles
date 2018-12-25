FROM base/archlinux

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S supervisor apache && \
    yes | pacman -Scc

VOLUME /data /config
EXPOSE 80 443

ADD httpd.conf /etc/httpd/conf/
ADD services.ini /etc/supervisor.d/
ADD my_init start_httpd /

CMD ["/my_init"]
