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
  && groupadd -g 1000 ubuntu && \
    useradd -r -u 1000 -g ubuntu ubuntu \
    && locale-gen "en_US.UTF-8"

USER ubuntu

RUN ansible-galaxy install -y \
  avinetworks.aviconfig,18.2.1 \
  avinetworks.avicontroller,18.2.1 \
  avinetworks.avisdk,18.2.1

CMD sleep infinity