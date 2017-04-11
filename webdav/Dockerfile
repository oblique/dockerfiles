FROM pritunl/archlinux

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S supervisor apache && \
    yes | pacman -Scc

RUN useradd -m -s /bin/bash user && \
    passwd -d user

ADD httpd.conf /etc/httpd/conf/

VOLUME /data
EXPOSE 80 443

ADD services.ini /etc/supervisor.d/
ADD my_init start_httpd /
CMD ["/my_init"]
