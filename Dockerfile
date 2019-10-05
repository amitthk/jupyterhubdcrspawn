# The MIT License
# SPDX short identifier: MIT
# Further resources on the MIT License
# Copyright 2018 Amit Thakur - amitthk - <e.amitthakur@gmail.com>
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
FROM centos/python-36-centos7

ARG GROUP_ID=org.mywire.amitthk
ARG REPO_BASE_URL=https://jvcdp-repo.s3-ap-southeast-1.amazonaws.com
ARG ADMIN_USER=jupyteradm
ARG ADMIN_UUID=10000
ARG PIP_INDEX=https://pypi.org/simple
ARG APP_ROOT=/opt/app-root
ARG ARTIFACT_ID=jupyterhub
ARG ARTIFACT_VERSION=1.0.0
ARG ARTIFACT_TYPE=tar.gz
ARG ARTIFACT_URL=https://files.pythonhosted.org/packages/54/7f/c0558a140ad329f304dc1cf55a2299cd990451ec68c94d6fe0ce1be6d712/jupyterhub-1.0.0.tar.gz
ARG ADMIN_USER_PASS=jupyteradm

ENV GROUP_ID=${GROUP_ID} \
    REPO_BASE_URL=${REPO_BASE_URL} \
    ADMIN_UUID=${ADMIN_UUID} \
    PIP_INDEX=${PIP_INDEX} \
    APP_ROOT=${APP_ROOT} \
    ARTIFACT_ID=${ARTIFACT_ID}\
    ARTIFACT_VERSION=${ARTIFACT_VERSION}\
    ARTIFACT_TYPE=${ARTIFACT_TYPE}\
    MANPATH=/opt/rh/rh-python36/root/usr/share/man:/opt/rh/rh-nodejs10/root/usr/share/man:/opt/rh/httpd24/root/usr/share/man: \
    HOSTNAME=b59c0cba29aa \
    PIP_NO_CACHE_DIR=off \
    TERM=xterm \
    LIBRARY_PATH=/opt/rh/httpd24/root/usr/lib64 \
    PYTHONUNBUFFERED=1 \
    NODEJS_SCL=rh-nodejs10 \
    X_SCLS="rh-python36 rh-nodejs10 httpd24"  \
    LC_ALL=en_US.UTF-8 \
    PYTHONIOENCODING=UTF-8 \
    LD_LIBRARY_PATH=/opt/rh/rh-python36/root/usr/lib64:/opt/rh/rh-nodejs10/root/usr/lib64:/opt/rh/httpd24/root/usr/lib64 \
    VIRTUAL_ENV=/opt/app-root \
    PYTHON_VERSION=3.6 \
    PATH=/opt/app-root/bin:/opt/rh/rh-python36/root/usr/bin:/opt/rh/rh-nodejs10/root/usr/bin:/opt/rh/httpd24/root/usr/bin:/opt/rh/httpd24/root/usr/sbin:/opt/app-root/src/.local/bin/:/opt/app-root/src/bin:/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
    PWD=/opt/app-root/src \
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    LANG=en_US.UTF-8 \
    PS1=(app-root)  \
    PLATFORM=el7 \
    HOME=/opt/app-root/src \
    SHLVL=1 \
    PYTHONPATH=/opt/rh/rh-nodejs10/root/usr/lib/python2.7/site-packages \
    XDG_DATA_DIRS=/opt/rh/rh-python36/root/usr/share:/usr/local/share:/usr/share \
    PKG_CONFIG_PATH=/opt/rh/rh-python36/root/usr/lib64/pkgconfig:/opt/rh/httpd24/root/usr/lib64/pkgconfig \
    _=/usr/bin/env


EXPOSE 8000 8081 8888

USER root

COPY files /tmp/

RUN useradd --no-log-init -u ${ADMIN_UUID} -g 0 -ms /bin/bash ${ADMIN_USER} \
    && for USR in $(cat /tmp/users);do useradd --no-log-init -g 0 -ms /bin/bash ${USR};done \
    && echo "${ADMIN_USER_PASS}" | passwd ${ADMIN_USER} --stdin  \
    && mkdir -p ~/.pip && cp /tmp/pip/pip.conf ~/.pip/pip.conf \ 
    && cp /tmp/yum/*.repo /etc/yum.repos.d/ \
    && mkdir -p /etc/pki/rpm-gpg/ && cp /tmp/yum/RPM-GPG-KEY-EPEL-7 /etc/pki/rpm-gpg/

RUN yum install -y wget unzip tar
    #&& yum install -y glibc glibc-common gcc gcc++  python-setuptools python-ldap java-1.8.0-openjdk java-1.8.0-openjdk-devel


RUN cd ${APP_ROOT}/ \
    && export GROUP_URL=`echo "${GROUP_ID}" | tr "." "/"` \
    && wget ${ARTIFACT_URL} \
    && tar -xzvf ${APP_ROOT}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.${ARTIFACT_TYPE} \
    && rm "${APP_ROOT}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.${ARTIFACT_TYPE}" \
    && pip3 install notebook \
    && pip3 install jupyterhub \
    && pip3 install jupyterhub-kubespawner dockerspawner \
    && pip3 install requests jupyterhub-ldap-authenticator ipyparallel

RUN npm install -g configurable-http-proxy

RUN chmod -R 0755 ${APP_ROOT} \
    && mkdir -p ${APP_ROOT}/conf \
    && chown -R ${ADMIN_USER}:root ${APP_ROOT} \
    && cp /tmp/*.sh ${APP_ROOT}/  && chmod 0775 ${APP_ROOT}/*.sh \
    && chmod g=u /etc/passwd
#    && cp /tmp/jupyterhub_config.py ${APP_ROOT}/conf/jupyterhub_config.py


WORKDIR ${APP_ROOT}

USER ${ADMIN_USER}

ENTRYPOINT [ "./entrypoint.sh" ]
CMD ["./run.sh"]
