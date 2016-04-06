#! /bin/bash

docker build -t luanmuniz/phearjs --rm=true .
docker stop phearjs
docker rm phearjs
docker run -d -p 8100:8100 --name phearjs luanmuniz/phearjs
#docker exec -it phearjs bash