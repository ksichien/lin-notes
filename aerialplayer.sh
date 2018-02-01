#!/bin/bash

MPV="mpv --really-quiet --shuffle --no-audio --fs --loop=inf --no-stop-screensaver --wid=${XSCREENSAVER_WINDOW} --panscan=1"
DAY="${HOME}/Aerial/*-day-*.mov"
NIGHT="${HOME}/Aerial/*-night-*.mov"

TIMEOFDAY=$(date +"%H")

if [ ${TIMEOFDAY} -gt 7 -a ${TIMEOFDAY} -le 19 ]
then
    eval "${MPV} ${DAY}"
else
    eval "${MPV} ${NIGHT}"
fi
