#!/usr/bin/env bash

if [ -c '/tmp/renode_instance.pid' ]; then
    printf 'Waiting for Renode shut down';
    while [ -c /proc/$(cat /tmp/renode_instance.pid)/exe ]; do
        printf '.';
        sleep 1;
    done;
fi

renode utils/RenodeLoadScript.resc --disable-xwt --hide-monitor --pid-file=/tmp/renode_instance.pid
