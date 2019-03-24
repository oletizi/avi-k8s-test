#FROM ubuntu:xenial
FROM alpine:3.9

RUN apk update \
  && apk add \
    bash \
    git \
    vim \
    emacs \
    python \
    ansible \
    sudo \
    curl \
    busybox-extras \
    jq \
  && adduser --disabled-password --gecos "" avi

COPY avi.sudo /etc/sudoers.d/avi
USER avi

RUN ansible-galaxy install \
  avinetworks.aviconfig,18.2.1 \
  avinetworks.avicontroller,18.2.1 \
  avinetworks.avisdk,18.2.1 \
  && (cd ${HOME} && git clone https://github.com/avinetworks/devops.git)

CMD tail -f /dev/null

