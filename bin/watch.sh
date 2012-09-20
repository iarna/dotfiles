#!/bin/sh
(while true; do (echo -en '\x1b[2J\x1b[H';bash -c "$@") 2>&1 > /tmp/watch.out; cat /tmp/watch.out; rm /tmp/watch.out ; sleep 1 ; done)
