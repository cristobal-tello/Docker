FROM		node:latest
MAINTAINER	ctello (cristobal.tello@t-systems.com)
ENV		NODE_ENV=production
COPY 		. /var/www
WORKDIR		/var/www
RUN		npm install
EXPOSE		$PORT
ENTRYPOINT	["npm","start"]
