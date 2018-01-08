FROM krallin/ubuntu-tini:trusty
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list
RUN sed -i '/security/d' /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install --force-yes rng-tools reprepro createrepo vim python-pip

RUN pip install pip2pi
RUN pip install --upgrade setuptools
RUN apt-get -y install python-dev libffi-dev libss-dev

COPY pip.conf /root/.pip/pip.conf


COPY keys /keys/

RUN gpg --allow-secret-key-import  --import /keys/private.key
