FROM oblique/archlinux-yay

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S supervisor && \
    sudo -u aur yay --noconfirm -S sonarr && \
    pacman -Qtdq | xargs -r pacman --noconfirm -Rcns && \
    rm -rf /home/aur/.cache

RUN useradd -m -s /bin/sh user && \
    passwd -d user

VOLUME /config /data
EXPOSE 8989

ADD services.ini /etc/supervisor.d/
ADD my_init /
CMD ["/my_init"]
