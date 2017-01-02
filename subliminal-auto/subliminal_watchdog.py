#!/usr/bin/env python3
import os
import time
import glob
import shutil
import threading
from datetime import timedelta, datetime
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from babelfish import *
from subliminal import *
import enzyme


watch_dirs = set((os.environ.get('WATCH_DIRS') or '/data').split(':'))
langs = set((os.environ.get('LANGS') or 'en').split(','))

providers = os.environ.get('PROVIDERS')
if providers:
    providers = set(providers.split(','))

provider_configs = {}
for x in ['addic7ed', 'legendastv', 'opensubtitles', 'subscenter']:
    user = os.environ.get(x.upper() + '_USER')
    passwd = os.environ.get(x.upper() + '_PASS')
    if user and passwd:
        provider_configs[x] = {'username' : user, 'password': passwd}
if len(provider_configs) == 0:
    provider_configs = None


def is_video_file(path):
    return os.path.isfile(path) and path.endswith(VIDEO_EXTENSIONS)


def is_valid_mkv(path):
    with open(path, 'rb') as f:
        try:
            enzyme.MKV(f)
            return True
        except enzyme.exceptions.MalformedMKVError:
            return False


def download_subs(path):
    if not is_video_file(path):
        return
    t = threading.Thread(target=_download_subs, args=[path])
    t.start()


def _download_subs(path):
    # wait up to 5 hours for the video to get downloaded
    print("[{}] Waiting for the video to be downloaded".format(path))
    download_wait_time = datetime.now() + timedelta(hours=5)
    while datetime.now() < download_wait_time:
        ext = os.path.splitext(path)[1]
        if ext.lower() == '.mkv':
            if is_valid_mkv(path):
                break
        elif os.path.getsize(path) > 10485760:
            break
        time.sleep(10)

    # if file is less than 10mb, do nothing
    if os.path.getsize(path) <= 10485760:
        print("[{}] Ingore file because is less than 10mb".format(path))
        return

    # read video file
    print("[{}] Gathering information".format(path))
    video = scan_video(path)
    refine(video)

    # check every 10 minutes for the subtitles. if within 2 days they are not
    # released then stop.
    tries = 0
    while video.age.days < 2:
        tries += 1
        video.subtitle_languages |= set(core.search_external_subtitles(path).values())

        # if subtitle's language is undefined, then assume that is english
        if Language('und') in video.subtitle_languages:
            video.subtitle_languages.remove(Language('und'))
            video.subtitle_languages |= {Language('eng')}

        print("[{}] Existing languages: {}".format(path,
            ', '.join(str(x) for x in video.subtitle_languages)))

        languages = set(Language.fromietf(x) for x in langs)
        languages -= video.subtitle_languages
        if not languages:
            break

        print("[{}] Need languages: {}".format(path,
            ', '.join(str(x) for x in languages)))

        # sleep for 10 minutes but not if this is the first 2 tries
        if tries > 2:
            time.sleep(10 * 60)

        # if file got deleted while we were sleeping, then stop
        if not video.exists:
            break

        # download subtitles
        print("[{}] Downloading subtitles".format(path))
        best_subtitles = download_best_subtitles([video], languages,
                providers=providers, provider_configs=provider_configs)

        # save subtitles
        if best_subtitles:
            save_subtitles(video, best_subtitles[video])

    print("[{}] Done".format(path))


def rename_subs(src_path, dest_path):
    if not is_video_file(src_path) or not is_video_file(dest_path):
        return

    src_name = os.path.splitext(src_path)[0]
    dest_name = os.path.splitext(dest_path)[0]

    for x in glob.glob(src_name + '*.srt'):
        old_path = x
        new_path = old_path.replace(src_name, dest_name)
        shutil.move(old_path, new_path)


class EventHandler(FileSystemEventHandler):
    def on_created(self, event):
        download_subs(event.src_path)

    def on_moved(self, event):
        rename_subs(event.src_path, event.dest_path)
        download_subs(event.dest_path)


region.configure('dogpile.cache.memory', expiration_time=timedelta(days=1))
event_handler = EventHandler()
observers = []

for x in watch_dirs:
    if not os.path.isdir(x):
        print("`{}` is not a valid directory".format(x))
        continue
    abspath = os.path.abspath(x)
    print("Watching '{}'".format(abspath))
    observer = Observer()
    observer.schedule(event_handler, abspath, recursive=True)
    observer.start()
    observers.append(observer)

if len(observers) == 0:
    print('No valid directories')
    exit(1)

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    for x in observers:
        x.stop()

for x in observers:
    x.join()
