FROM oblique/archlinux-pacaur

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S supervisor && \
    sudo -u aur pacaur --noconfirm --noedit -S sonarr && \
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
    yes | pacman -Scc && \
    rm -rf /home/aur/.cache/pacaur

RUN useradd -m -s /bin/sh user && \
    passwd -d user

VOLUME /config /data
EXPOSE 8989

ADD services.ini /etc/supervisor.d/
ADD my_init /
CMD ["/my_init"]
