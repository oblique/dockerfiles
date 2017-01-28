FROM alpine

RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk add --no-cache ruby openssh-client openvpn stunnel dante-server@testing

EXPOSE 1080

ADD sockd.conf /etc
ADD airvpn.rb start_vpn.rb /
CMD ["/airvpn.rb"]
