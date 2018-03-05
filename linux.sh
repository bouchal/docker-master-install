#!/bin/bash

[ -z "$SUPERVISOR_PWD" ] && echo "Need to set SUPERVISOR_PWD" && exit 1;

# Installation of Docker
apt-get update
apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

apt-get update

apt-get install -y docker-ce


# Installation of docker-compose
curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Installation of supervisor
apt-get install -y supervisor

supervisorPort=${SUPERVISOR_PORT:-9001}
supervisorUsername=${SUPERVISOR_USERNAME:-"root"}
supervisorShaPwd=($(echo -n $SUPERVISOR_PWD | sha1sum))


cat > /etc/supervisor/conf.d/inet_http_server.conf << EOL
[inet_http_server]
port=*:$supervisorPort
username=$supervisorUsername
password={SHA}$supervisorShaPwd
EOL

service supervisor restart