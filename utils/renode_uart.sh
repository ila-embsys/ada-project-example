#!/usr/bin/env bash

# while true; do
    printf 'Waiting for Renode UART available';

    while [ ! -e '/tmp/renode_uart' ]; do
        printf '.'; sleep 1;
    done

    screen /tmp/renode_uart
# done
