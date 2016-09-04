FROM debian

ADD install.sh /
RUN /install.sh && rm -f /install.sh

RUN useradd -s /bin/bash user && \
        usermod -d /config user && \
        passwd -d user

VOLUME /config
EXPOSE 9117 9118

ADD jackett.conf /etc/supervisor/conf.d
ADD my_init /
CMD /my_init
