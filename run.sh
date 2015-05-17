#!/bin/sh
IMAGE=asterisk
docker run -dit --net=host --privileged --name=$IMAGE tomo-chan/asterisk /bin/bash
docker exec $IMAGE service asterisk start
