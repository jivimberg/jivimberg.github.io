FROM ubuntu:16.04

ENV LC_ALL C.UTF-8

# Get dependencies
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 575159689BEFB442 && \
  echo 'deb http://download.fpcomplete.com/ubuntu xenial main'| tee /etc/apt/sources.list.d/fpco.list && \
  apt-get update && apt-get install -y \
  bundler \
  git \
  ruby && \
  apt-get clean

# Install octopress
RUN git clone git://github.com/imathis/octopress.git /octopress && \
    cd /octopress && \
    gem install bundler && \
    bundle install

# Expose default port for octopress preview
EXPOSE 4000
WORKDIR /octopress