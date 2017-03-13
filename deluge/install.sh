#!/bin/bash
set -e

github_latest_release() {
    curl -L "https://api.github.com/repos/${1}/releases/latest" 2> /dev/null | \
        grep -m1 tag_name | sed 's|.*"tag_name": "v\([^"]\+\).*|\1|'
}

pacman --noconfirm -Syyu
pacman --noconfirm -S supervisor deluge python2-mako python2-service-identity
pacman -Qtdq | xargs -r pacman --noconfirm -Rcns
yes | pacman -Scc

mkdir -p /opt
cd /opt

ver=$(github_latest_release ratanakvlun/deluge-ltconfig)
curl -L -o ltConfig.egg https://github.com/ratanakvlun/deluge-ltconfig/releases/download/v${ver}/ltConfig-${ver}-py2.7.egg
