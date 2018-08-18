## Image

Docker image of [ArchLinux](https://www.archlinux.org) with [yay](https://github.com/Jguer/yay) installed.

## Usage

Install package from official repositories:

```
pacman --noconfirm -S <package>
```

Install package from AUR:

```
sudo -u aur yay --noconfirm -S <package>
```

Cleanup:

```
pacman -Qtdq | xargs -r pacman --noconfirm -Rcns
yes | pacman -Scc
rm -rf /home/aur/.cache
```
