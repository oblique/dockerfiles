FROM pritunl/archlinux

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S supervisor deluge python2-mako && \
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
    pacman --noconfirm -Scc && \
    rm -rf /var/cache/pacman/pkg/*

RUN useradd -m -s /bin/sh user && \
    passwd -d user

VOLUME /config /data
EXPOSE 8112 58846

ADD services.ini /etc/supervisor.d/
ADD my_init /
CMD ["/my_init"]
