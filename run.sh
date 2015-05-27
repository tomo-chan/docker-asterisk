#!/bin/sh
IMAGE=asterisk

if [ "`docker ps -a | grep -e " asterisk "`" == "" ]; then
  if [ ! "`ls -A`" == "" ]; then
    echo Current directory is not empty.
    exit 1
  fi

### -it must need to run this container becahse of memory leak! ###
### --log-driver=none need to prevent memory leak. ###

#  docker run -it -d \
#    --log-driver=none \
#    --name=$IMAGE tomo-chan/asterisk

#  docker run -it -d --net=host --cap-add=NET_ADMIN \
#    --log-driver=none \
  docker run -it -d --net=host --cap-add=NET_ADMIN \
    -v `pwd`/etc/asterisk:/etc/asterisk \
    -v `pwd`/var/log/asterisk:/var/log/asterisk \
    -v /etc/localtime:/etc/localtime:ro \
    --name=$IMAGE tomo-chan/asterisk

# Too heavy.
#  docker run -it -d \
#    -p 5060:5060/udp -p 8088:8088 -p 10000-20000:10000-20000/udp \
#    -v `pwd`/etc/asterisk:/etc/asterisk \
#    --name=$IMAGE tomo-chan/asterisk

else
  docker start $IMAGE
fi
