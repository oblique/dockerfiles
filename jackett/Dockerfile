FROM debian

ADD install.sh /
RUN /install.sh && rm -f /install.sh

RUN useradd -m -s /bin/bash user && \
        passwd -d user

VOLUME /config
EXPOSE 9117

ADD my_init start /
CMD /my_init
