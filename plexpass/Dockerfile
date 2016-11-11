FROM debian:jessie

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install locales-all curl supervisor jq && \
    mkdir /build && \
    cd /build && \
    ver=$(curl -L 'https://plex.tv/api/downloads/1.json?channel=plexpass' | jq -r .computer.Linux.version) && \
    curl -L -o pms.deb https://downloads.plex.tv/plex-media-server/${ver}/plexmediaserver_${ver}_amd64.deb && \
    dpkg -i pms.deb && \
    apt-get -y install -f && \
    cd / && \
    rm -rf /build && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/sh user && \
    passwd -d user

VOLUME /config /data

# plex server
EXPOSE 32400
# DLNA server
EXPOSE 32469 1900/udp
# network discovery
EXPOSE 32410/udp 32412/udp 32413/udp 32414/udp

ADD services.conf /etc/supervisor/conf.d/
ADD my_init start_pms /
CMD ["/my_init"]
