#!/usr/bin/python3
"""
This script will download the latest Apple TV Aerial screensavers.
Inspired by https://gist.github.com/Dhertz/9dd69eaad092d0c0fe96
"""
import json
import os
import requests

DLDIR = os.getenv("HOME") + '/Aerial/'

if not os.path.exists(DLDIR):
    os.makedirs(DLDIR)

RSP = requests.get('http://a1.phobos.apple.com/us/r1000/000/Features/atv/' +
                   'AutumnResources/videos/entries.json')

ARL = json.loads(RSP.text)
for aerial in ARL:
    for asset in aerial['assets']:
        filename = asset['url'].split('/')
        filepath = DLDIR + filename[-1]
        if not os.path.isfile(filepath):
            print("Downloading %s" % (asset['url'],))
            video = requests.get(asset['url'], stream=True)
            with open(filepath, "wb") as videoFile:
                print("Writing %s to %s" % (asset['id'], filepath))
                for chunk in video.iter_content(chunk_size=1024):
                    if chunk:
                        videoFile.write(chunk)
