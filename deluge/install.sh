#!/bin/bash
set -e

pacman --noconfirm -Syyu
pacman --noconfirm -S supervisor deluge python2-mako python2-service-identity
pacman -Qtdq | xargs -r pacman --noconfirm -Rcns
yes | pacman -Scc

mkdir -p /opt
cd /opt

ver=$(curl https://github.com/ratanakvlun/deluge-ltconfig/releases/latest | sed 's|.*tag/v\([^"]\+\).*|\1|')
curl -L -o ltConfig.egg https://github.com/ratanakvlun/deluge-ltconfig/releases/download/v${ver}/ltConfig-${ver}-py2.7.egg
