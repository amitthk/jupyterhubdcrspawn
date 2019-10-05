#!/bin/bash
docker run -d -p 8000:8000 -p 8081:8081 -p 8888:8888  -v $(pwd)/home:/home \
 -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd)/conf:/opt/app-root/conf \
 -e HUB_IP='0.0.0.0' -e HUB_CONNECT_IP='192.168.1.122' \
 amitthk/jupyterhub-centos:latest