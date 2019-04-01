FROM archlinux/base

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S curl grep tar mono sqlite supervisor libmediainfo libgdiplus

RUN useradd -m -s /bin/bash user && \
    passwd -d user

RUN mkdir -p /opt && \
    cd /opt && \
    ver=$(curl -L https://api.github.com/repos/Radarr/Radarr/releases | grep -m1 tag_name | sed 's|.*"tag_name": "v\([^"]\+\).*|\1|') && \
    curl -L -o radarr.tar.gz "https://github.com/Radarr/Radarr/releases/download/v${ver}/Radarr.develop.${ver}.linux.tar.gz" && \
    tar xvf radarr.tar.gz && \
    rm radarr.tar.gz && \
    ([ -d Radarr ] || mv [rR]adarr* Radarr) && \
    chmod -R +r Radarr

VOLUME /config /data
EXPOSE 7878

ADD services.ini /etc/supervisor.d/
ADD my_init /
CMD ["/my_init"]
