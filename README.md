Quick installation of __Docker__, __Docker-Composer__ and __Supervisor__ on empty server.

# Goal

Very often I need run simple instance with only few docker containers.
With this script is installation really simple and fast and I don't need to find every tutirials everytime when I do it.

# Installation

Connect to server and make sure you have installed `curl`.

```
apt-get install -y curl
```

Then simply run this command

```
SUPERVISOR_PORT=8080 \
SUPERVISOR_USERNAME=admin \
SUPERVISOR_PWD=SecretPassword \
\
INSTALL_SCRIPT=$(curl -s "https://raw.githubusercontent.com/bouchal/docker-master-install/master/linux.sh") \
&& CHECKSUM=$(sha256sum <(echo -n $INSTALL_SCRIPT)  | cut -d ' ' -f 1) \
&& if [ "$CHECKSUM" != "269522dd5e7d5cff551e6fdde3694f0d048bc496af466619858cf6654cfeddf9" ]; then echo "INSTALL SCRIPT CHECKSUM DON'T MACH"; else \
	SUPERVISOR_PORT=$SUPERVISOR_PORT \
	SUPERVISOR_USERNAME=$SUPERVISOR_USERNAME \
	SUPERVISOR_PWD=$SUPERVISOR_PWD \
	bash <(echo "$INSTALL_SCRIPT"); \
fi;
```

__Only required variable is `SUPERVISOR_PWD`.__

Default value for `SUPERVISOR_USER` is `root`

Default value for `SUPERVISOR_PORT` is `9001`


# Usage

Usage of Supervisor and adding of new containers is really simple

## Supervisor HTTP administration

After installation you can find Supervisor HTTP administration on `http://[SERVER_IP]:[SUPERVISOR_PORT]` with basic access authentication.

## Adding new container

- In folder `/etc/supervisor/conf.d/` create new file with extension `.conf`. For example `php_docker.conf`.
- Fill this file with Supervisor config.

```
[program:php-docker]
directory=/var/docker/php
command=docker-compose up
stdout_events_enabled=true
stderr_events_enabled=true
autorestart=true
```

- Then restart supervisor with command `service supervisor restart`.
- __Profit!__
