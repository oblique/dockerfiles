#!/usr/bin/env python3
import os
import time
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler


watch_dirs = os.environ.get('WATCH_DIRS')
langs = os.environ.get('LANGS')
ext = os.environ.get('EXT')
addic7ed_user = os.environ.get('ADDIC7ED_USER')
addic7ed_pass = os.environ.get('ADDIC7ED_PASS')
legendastv_user = os.environ.get('LEGENDASTV_USER')
legendastv_pass = os.environ.get('LEGENDASTV_PASS')
opensubtitles_user = os.environ.get('OPENSUBTITLES_USER')
opensubtitles_pass = os.environ.get('OPENSUBTITLES_PASS')
subscenter_user = os.environ.get('SUBSCENTER_USER')
subscenter_pass = os.environ.get('SUBSCENTER_PASS')

if not watch_dirs:
    print('WATCH_DIRS is mandatory')
    exit(1)

if not langs:
    print('LANGS is mandatory')
    exit(1)

if not ext:
    ext = 'mkv,mp4,m4v,avi,mpg,mpeg,wmv,webm,mov'

watch_dirs = watch_dirs.split(':')
langs = langs.split(',')
ext = ext.split(',')


def is_video_file(path):
    for x in ext:
        if path.lower().endswith('.' + x.lower()):
            return True
    return False


def download_subs(path):
    if os.path.isdir(path):
        return

    if not is_video_file(path):
        return

    cmd = ['subliminal']

    if addic7ed_user and addic7ed_pass:
        cmd += ['--addic7ed', addic7ed_user, addic7ed_pass]
    if legendastv_user and legendastv_pass:
        cmd += ['--legendastv', legendastv_user, legendastv_pass]
    if opensubtitles_user and opensubtitles_pass:
        cmd += ['--opensubtitles', opensubtitles_user, opensubtitles_pass]
    if subscenter_user and subscenter_pass:
        cmd += ['--subscenter', subscenter_user, subscenter_pass]

    cmd += ['download', '-v']
    for x in langs:
        cmd += ['-l', x]
    cmd.append(path)

    subprocess.run(cmd)


class EventHandler(FileSystemEventHandler):
    def on_created(self, event):
        if not event.is_directory:
            download_subs(event.src_path)


event_handler = EventHandler()
observers = []

for x in watch_dirs:
    if not os.path.isdir(x):
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
