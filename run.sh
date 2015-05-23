#!/bin/sh
IMAGE=asterisk

if [ "$(`docker ps -a | grep -e " asterisk "`)" == "" ]; then
  if [ ! "$(`ls -A`)" == "" ]; then
    echo Current directory is not empty.
    exit 1
  fi
  docker run -d --net=host \
    -v `pwd`/etc/asterisk:/etc/asterisk \
    -v `pwd`/var/log/asterisk:/var/log/asterisk \
    --name=$IMAGE tomo-chan/asterisk
fi

docker start $IMAGE
