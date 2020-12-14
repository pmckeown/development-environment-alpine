FROM danielguerra/alpine-sdk:edge as builder

RUN abuild-keygen -a -n

WORKDIR /tmp/aports
RUN git pull
WORKDIR /tmp/aports/community/xrdp
RUN abuild fetch
RUN abuild unpack
RUN abuild deps
RUN abuild prepare
RUN abuild build
RUN abuild rootpkg

WORKDIR /tmp/aports/testing/xorgxrdp
RUN abuild fetch
RUN abuild unpack
RUN abuild deps
RUN abuild prepare
RUN abuild build
RUN abuild rootpkg

RUN echo sdk | sudo -S ls && echo "echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing'>>/etc/apk/repositories" | sudo sh
RUN echo sdk | sudo -S apk update
RUN echo sdk | sudo -S apk add xrdp-dev xorgxrdp-dev

# RUN STOP

FROM alpine:edge
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing">>/etc/apk/repositories

RUN apk --update --no-cache add \
    alpine-conf \
    bash \
    chromium \
    curl \
    dbus \
    faenza-icon-theme \
    firejail \
    git \
    jq \
    openssh \
    openssl \
    paper-gtk-theme \
    paper-icon-theme \
    pavucontrol \
    setxkbmap \
    slim \
    sudo \
    supervisor \
    thunar-volman \
    ttf-freefont \
    util-linux \
    vim \
    wget \
    wireshark \
    vlc-qt \
    xauth \
    xf86-input-keyboard \
    xf86-input-mouse \
    xf86-input-synaptics \
    xfce4 \
    xfce4-terminal \
    xinit \
    xorg-server \
    xorgxrdp \
    xrdp \
&& rm -rf /tmp/* /var/cache/apk/*

RUN mkdir -p /var/log/supervisor
# add scripts/config
ADD etc /etc
ADD bin /bin

# prepare user alpine
RUN addgroup alpine \
&& adduser  -G alpine -s /bin/sh -D alpine \
&& echo "alpine:alpine" | /usr/sbin/chpasswd \
&& echo "alpine    ALL=(ALL) ALL" >> /etc/sudoers

# prepare xrdp key
RUN xrdp-keygen xrdp auto

RUN apk add docker

EXPOSE 3389 22
VOLUME ["/etc/ssh"]
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
