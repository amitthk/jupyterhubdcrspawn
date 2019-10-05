#!/bin/bash
docker run -d -p 8000:8000 -v $(pwd)/home:/home -v /var/run/docker.sock:/var/run/docker.sock amitthk/jupyterhub-centos:latest