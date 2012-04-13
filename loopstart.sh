#!/bin/sh

while true ; do
  coffee -w main.coffee -w ./lib/dataset.coffee
  sleep 1
done
