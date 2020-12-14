# development-environment-alpine

Forked and tweaked from danielguerra/alpine-xfce-xrdp

## How to run

### OSX
`docker run -v /var/run/docker.sock:/var/run/docker.sock -it <ImageID> /bin/bash`

The docker socket is forwarded to allow the hosted container to access the Docker Daemon of the
host.