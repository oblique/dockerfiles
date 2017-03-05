## Image

Docker image of [ArchLinux](https://www.archlinux.org) with [pacaur](https://github.com/rmarquis/pacaur) installed.

## Usage

Install package from official repositories:

```
pacman --noconfirm -S <package>
```

Install package from AUR:

```
sudo -u aur pacaur --noconfirm --noedit -S <package>
```

Cleanup:

```
pacman -Qtdq | xargs -r pacman --noconfirm -Rcns
yes | pacman -Scc
rm -rf /home/aur/.cache/pacaur
```
