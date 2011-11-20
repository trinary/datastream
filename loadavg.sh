#!/bin/sh
while true ; do
  sleep 3
  t="`date +%s`000"
  l=`uptime | awk '{print $10*10}'`
  curl -X POST -d "{\"value\": $l, \"timestamp\": $t}" -H 'Content-Type: application/json' http://localhost:3000/sets/asdf/data
  echo
done
