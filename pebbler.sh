#!/bin/bash

cd "${0%/*}"

prefix="pebbles.totals.$$"

cat $1 | tr " " "\n" | while read PEBBLE; do
    echo -n $PEBBLE " " >&2
    { ./d11-pebbles.rb $PEBBLE | tee "/tmp/$prefix.$RANDOM"; } &
done

while ps | grep -q "[d]11-pebbles"; do sleep 0.5; done

echo
find /tmp/ -name "$prefix.*" | xargs cat | awk '{ sum += $1 } END { print sum }'
