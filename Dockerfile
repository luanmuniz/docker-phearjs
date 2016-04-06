FROM debian:wheezy
MAINTAINER luan@luanmuniz.com.br

ENV NOVE_ENV production
ENV DEBIAN_FRONTEND noninteractive

ENV NVM_VERSION v0.31.0
ENV NODE_VERSION v4.4.2
ENV PHANTOMJS_VERSION 2.1.1
ENV PHEARJS_VERSION 0.5.0

ENV NODE_DEPENDENCES g++ gcc make python ca-certificates curl git apt-utils
ENV PHANTOMJS_DEPENDENCES bzip2 libfontconfig1-dev libssl-dev
ENV PHEARJS_DEPENDENCES procps

# Normalize Bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install Dependences
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y $NODE_DEPENDENCES $PHANTOMJS_DEPENDENCES $PHEARJS_DEPENDENCES --no-install-recommends

# Install Nodejs
RUN git clone -b $NVM_VERSION https://github.com/creationix/nvm.git /opt/nvm
WORKDIR /opt/nvm

RUN source /opt/nvm/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && nvm alias default $NODE_VERSION

RUN ln -s /opt/nvm/versions/node/$NODE_VERSION/bin/node /usr/bin/node \
    && ln -s /opt/nvm/versions/node/$NODE_VERSION/bin/npm /usr/bin/npm

RUN npm install -g node-gyp nan \
    && npm update

# Install PhantomJS
RUN curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 --output /opt/phantomjs.tar.bz2
RUN tar -xf /opt/phantomjs.tar.bz2 -C /opt
RUN rm -rf /opt/phantomjs.tar.bz2
RUN ln -s /opt/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

# Install PhearJS
RUN git clone -b $PHEARJS_VERSION https://github.com/Tomtomgo/phearjs.git /opt/phearjs
WORKDIR /opt/phearjs
RUN npm install

# Add Phearjs Config
ADD . /opt/src/

# Clean Installation
RUN rm -rf /tmp/* \
    && apt-get clean

EXPOSE 8100

CMD ["node", "/opt/phearjs/phear.js", "-e", "development", "-c", "/opt/src/config.json"]