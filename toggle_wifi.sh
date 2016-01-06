#!/bin/bash

STATUS_STATE="$(nmcli -t -f STATE g)"

if [ "$STATUS_STATE" = "asleep" ] || [ "$STATUS_STATE" = "disconnected" ]; then
    nmcli radio wifi on
elif [ "$STATUS_STATE" = "connected" ] ; then
    nmcli radio wifi off
else
    notify-send "`nmcli -f STATE g`"
    notify-send "`nmcli -f WIFI g`"
fi
