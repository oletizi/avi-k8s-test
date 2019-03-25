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
  && cd /tmp/ \
  && curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-239.0.0-linux-x86_64.tar.gz | tar xfvz - \
  && /tmp/google-cloud-sdk/install.sh \
  && rm -rf /tmp/google-cloud-sdk \
  && adduser --disabled-password --gecos "" avi

COPY avi.sudo /etc/sudoers.d/avi
USER avi

RUN echo "export PATH=${PATH}:/usr/local/google-cloud-sdk/bin" >> ${HOME}/.bashrc \
  && ansible-galaxy install \
  avinetworks.aviconfig,18.2.1 \
  avinetworks.avicontroller,18.2.1 \
  avinetworks.avisdk,18.2.1 \
  && (cd ${HOME} && git clone https://github.com/avinetworks/devops.git)

CMD tail -f /dev/null

