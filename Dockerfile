FROM centos:centos8.3.2011

ENV TZ=Pacific/Auckland

RUN yum update && \
    yum install -y \
    epel-release \
    curl \
    git-core \
    make \
    wget \
    vim \
    jq \
    openssl \
    sudo

