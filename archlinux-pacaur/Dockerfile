FROM pritunl/archlinux

# Use `/usr/bin/true` as a dummy editor
ENV EDITOR=true

RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S git sudo binutils make fakeroot gcc && \
    useradd -m -s /bin/bash aur && \
    passwd -d aur && \
    echo 'aur ALL=(ALL) ALL' > /etc/sudoers.d/aur && \
    echo 'Defaults env_keep += "EDITOR"' >> /etc/sudoers.d/aur && \
    mkdir /build && \
    chown -R aur:aur /build && \
    cd /build && \
    sudo -u aur gpg --recv-key 487EACC08557AD082088DABA1EB2638FF56C0C53 && \
    sudo -u aur git clone --depth 1 https://aur.archlinux.org/cower.git && \
    cd cower && \
    sudo -u aur makepkg --noconfirm -si && \
    cd .. && \
    sudo -u aur git clone --depth 1 https://aur.archlinux.org/pacaur.git && \
    cd pacaur && \
    sudo -u aur makepkg --noconfirm -si && \
    yes | pacman -Scc && \
    cd / && \
    rm -rf /build

CMD ["/bin/bash"]
