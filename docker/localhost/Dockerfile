FROM ubuntu:xenial

RUN apt-get update \
  && apt-get install -y software-properties-common \
  && apt-add-repository -y ppa:ansible/ansible \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
    git \
    emacs \
    python \
    ansible \
    locales \
    sudo \
    curl \
    telnet \
    jq \
  && adduser --disabled-password ubuntu \
  && locale-gen "en_US.UTF-8"

COPY ubuntu.sudo /etc/sudoers.d/ubuntu
USER ubuntu

RUN ansible-galaxy install \
  avinetworks.aviconfig,18.2.1 \
  avinetworks.avicontroller,18.2.1 \
  avinetworks.avisdk,18.2.1

CMD sleep infinity

