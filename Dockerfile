# Use a recent Ubuntu base image with Python 3.8
FROM ubuntu:22.04

# Set environment variables
ENV APP_ROOT=/opt/app-root \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LANG=en_US.UTF-8 \
    PATH=/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    HOME=/opt/app-root/src \
    TERM=xterm \
    _=/usr/bin/env

EXPOSE 8000 8081 8888

USER root

# Install required packages and Python
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    tar \
    python3-pip \
    python3-dev \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --upgrade pip \
    && pip3 install notebook jupyterhub jupyterhub-kubespawner dockerspawner requests jupyterhub-ldap-authenticator ipyparallel oauthenticator \
    && npm install -g configurable-http-proxy

COPY files /tmp/

# Create user and set up permissions
RUN useradd --no-log-init -u 10000 -g 0 -ms /bin/bash jupyteradm \
    && echo "jupyteradm:jupyteradm" | chpasswd \
    && chmod -R 0755 ${APP_ROOT} \
    && mkdir -p ${APP_ROOT}/conf \
    && chown -R jupyteradm:root ${APP_ROOT} \
    && cp /tmp/*.sh ${APP_ROOT}/  && chmod 0775 ${APP_ROOT}/*.sh

WORKDIR ${APP_ROOT}

USER jupyteradm

ENTRYPOINT [ "./entrypoint.sh" ]
CMD ["./run.sh"]
