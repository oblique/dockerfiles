FROM debian

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install iodine dnsutils net-tools iptables && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

ADD my_init /

EXPOSE 53/udp

CMD '/my_init'
