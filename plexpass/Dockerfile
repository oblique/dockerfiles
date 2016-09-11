FROM oblique/archlinux-pacaur

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S supervisor && \
    sudo -u aur pacaur --noconfirm --noedit -S plex-media-server-plexpass && \
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
    pacman --noconfirm -Scc && \
    rm -rf /var/cache/pacman/pkg/* && \
    rm -rf /home/aur/.cache/pacaur

RUN useradd -m -s /bin/sh user && \
    passwd -d user

VOLUME /config /data

# plex server
EXPOSE 32400
# DLNA server
EXPOSE 32469 1900/udp
# network discovery
EXPOSE 32410/udp 32412/udp 32413/udp 32414/udp

ADD services.ini /etc/supervisor.d/
ADD my_init start_pms /
CMD ["/my_init"]
