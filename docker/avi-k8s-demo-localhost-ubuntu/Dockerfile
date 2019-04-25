FROM ubuntu:bionic

ARG avisdk_role_version
ARG aviconfig_role_version
ARG avicontroller_role_version

RUN sed -r -i -e 's/http:\/\/archive/mirror:\/\/mirrors/' -e 's/mirror:(.*?)\/ubuntu\//mirror:\1\/mirrors.txt/' /etc/apt/sources.list \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
       bash \
       git \
       gcc \
       make \
       m4 \
       vim \
       emacs-nox \
       openssh-client \
       python3 \
       python3-pip \
       python3-dev \
       musl-dev \
       libffi-dev \
#       openssl-dev \
       sudo \
       curl \
#       busybox-extras \
       jq \
  && ln -s /usr/bin/python3 /usr/bin/python \
  && ln -s /usr/bin/pip3 /usr/bin/pip \
  && pip3 install avisdk ansible \
  && cd /usr/local/ \
  && curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-239.0.0-linux-x86_64.tar.gz | tar xfvz - \
  && /usr/local/google-cloud-sdk/install.sh \
  && /usr/local/google-cloud-sdk/bin/gcloud components install kubectl \
  && rm -rf /tmp/google-cloud-sdk \
#  && apt-get remove -y \
#     gcc \
#     make \
#     python3-dev \
#     musl-dev \
#     libffi-dev \
#  && apt-get autoremove \
  && adduser --disabled-password --gecos "" avi

COPY avi.sudo /etc/sudoers.d/avi
COPY motd /etc/motd
USER avi

RUN ssh-keygen -t rsa -N "" -f ${HOME}/.ssh/id_rsa\
  && echo 'export PATH=${PATH}:/usr/local/google-cloud-sdk/bin' >> ${HOME}/.bashrc \
  && echo 'export PS1="\u@\h:\w$ "' >> ${HOME}/.bashrc \
  && echo 'cd ${HOME}' >> ${HOME}/.bashrc \
  && echo 'cat /etc/motd' >> ${HOME}/.bashrc \
  && ansible-galaxy install \
    avinetworks.aviconfig,${aviconfig_role_version} \
    avinetworks.avisdk,${avisdk_role_version} \
    avinetworks.avicontroller,${avicontroller_role_version} \
  && (cd ${HOME} && git clone https://github.com/avinetworks/devops.git)

CMD tail -f /dev/null

