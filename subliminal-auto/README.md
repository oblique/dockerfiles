**NOTE: I'm not going to maintain this anymore because I switched to [Sub-Zero](https://github.com/pannal/Sub-Zero.bundle) plugin of Plex**

## Image

This image watch directories of your choice for new videos. If video is
found then it runs [subliminal](https://github.com/Diaoul/subliminal) to download the subtitles.

## Environment variables

* `PUID` - UID of the process (default: 1000)
* `PGID` - GID of the process (default: 1000)
* `WATCH_DIRS` - Colon separated watch directories (default: /data)
* `LANGS` - Comma separated, [2 letter country code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) (default: en)
* `PROVIDERS` - Comma separated providers (check `-p` of `subliminal download --help`)
* `ADDIC7ED_USER` - [addic7ed](http://www.addic7ed.com) username
* `ADDIC7ED_PASS` - [addic7ed](http://www.addic7ed.com) password
* `LEGENDASTV_USER` - [legendas.tv](http://legendas.tv) username
* `LEGENDASTV_PASS` - [legendas.tv](http://legendas.tv) password
* `OPENSUBTITLES_USER` - [opensubtitles](http://www.opensubtitles.org) username
* `OPENSUBTITLES_PASS` - [opensubtitles](http://www.opensubtitles.org) password
* `SUBSCENTER_USER` - [subscenter](http://www.subscenter.org) username
* `SUBSCENTER_PASS` - [subscenter](http://www.subscenter.org) password

## Usage

```
docker run -d \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /path/to/media:/data \
    oblique/subliminal-auto
```

```
docker run -d \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -e WATCH_DIRS=/movies:/series \
    -e LANGS=en,el \
    -v /path/to/movies:/movies \
    -v /path/to/series:/series \
    oblique/subliminal-auto
```

## CouchPotato integration

The reason that I created this image is because CouchPotato was doing
a bad job with the subtitles. Here's how you can integrate it:

On CouchPotato, go to `Settings`, then `Renamer` and set `File Naming` to `<original>.<ext>`.
Also disable `Download subtitles`.
