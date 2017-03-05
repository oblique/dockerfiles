#!/bin/bash
set -e

pacman --noconfirm -Syyu mono curl supervisor

mkdir -p /build
cd /build

# install jackett
ver=$(curl https://github.com/Jackett/Jackett/releases/latest | sed 's|.*tag/\([^"]\+\).*|\1|')
curl -L -o jackett.tar.gz https://github.com/Jackett/Jackett/releases/download/${ver}/Jackett.Binaries.Mono.tar.gz
tar xvf jackett.tar.gz -C /opt
[[ -d /opt/Jackett ]] || mv /opt/Jackett* /opt/Jackett

# install jackett-public
ver=$(curl https://github.com/dreamcat4/Jackett-public/releases/latest | sed 's|.*tag/\([^"]\+\).*|\1|')
curl -L -o jackett-public.tar.gz https://github.com/dreamcat4/Jackett-public/releases/download/${ver}/Jackett-public.Binaries.Mono.tar.gz
tar xvf jackett-public.tar.gz -C /opt
[[ -d /opt/Jackett-public ]] || mv /opt/Jackett-public* /opt/Jackett-public

cd /
rm -rf /build
yes | pacman -Scc
