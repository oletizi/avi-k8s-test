FROM alpine:3.9

ARG ansible_playbook_version

RUN apk update \
  && apk add \
    bash \
    git \
    vim \
    emacs \
    openssh \
    python \
    py-pip \
    ansible \
    sudo \
    curl \
    busybox-extras \
    jq \
  && pip install avisdk \
  && cd /usr/local/ \
  && curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-239.0.0-linux-x86_64.tar.gz | tar xfvz - \
  && /usr/local/google-cloud-sdk/install.sh \
  && /usr/local/google-cloud-sdk/bin/gcloud components install kubectl \
  && rm -rf /tmp/google-cloud-sdk \
  && adduser --disabled-password --gecos "" avi

COPY avi.sudo /etc/sudoers.d/avi
COPY motd /etc/motd
USER avi

RUN ssh-keygen -t rsa -N "" \
  && echo 'export PATH=${PATH}:/usr/local/google-cloud-sdk/bin' >> ${HOME}/.bashrc \
  && echo 'export PS1="\u@\h:\w$ "' >> ${HOME}/.bashrc \
  && echo 'cd ${HOME}' >> ${HOME}/.bashrc \
  && echo 'cat /etc/motd' >> ${HOME}/.bashrc \
  && ansible-galaxy install \
  avinetworks.aviconfig,${ansible_playbook_version} \
  avinetworks.avisdk,${ansible_playbook_version} \
  avinetworks.avicontroller,${ansible_playbook_version} \
  && (cd ${HOME} && git clone https://github.com/avinetworks/devops.git)

CMD tail -f /dev/null

