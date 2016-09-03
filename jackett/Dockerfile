FROM debian

ADD install.sh /
RUN /install.sh && rm -f /install.sh

RUN useradd -m -s /bin/bash user && \
        passwd -d user && \
        mkdir -p /home/user/.config && \
        ln -s /config/jackett /home/user/.config/Jackett && \
        ln -s /config/jackett-public /home/user/.config/Jackett-public

VOLUME /config
EXPOSE 9117 9118

ADD jackett.conf /etc/supervisor/conf.d
ADD my_init /
CMD /my_init
