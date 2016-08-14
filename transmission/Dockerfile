FROM debian

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install transmission-daemon && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash user
USER user

VOLUME ['/config' '/downloads' '/watch']
EXPOSE 9091

ADD my_init /
CMD '/my_init'
