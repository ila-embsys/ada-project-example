#!/usr/bin/env bash

printf 'Waiting for Telnet RTT available.';

# Wait Telnet server
while ! nc -z localhost 19021 ; do
    printf '.'; sleep 1;
done

# split previous message
printf '\r\n\r\n'

# prevent "ERROR: Connection refused - There already is an active connection."
sleep 1;

# raw -- pass control characters like Ctrl+C
# -icanon -- disable buffering and send every char otherwise shell will broken
# -echo -- shell echos themself.
stty raw -icanon -echo

nc localhost 19021
