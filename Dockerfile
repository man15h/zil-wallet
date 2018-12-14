FROM node:8-slim

RUN set -ex \
	&& mkdir -p /data/app \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends git python make g++

ADD app /data/app

COPY package.json nuxt.config.js postcss.config.js tailwind.js /data/

WORKDIR /data

RUN npm cache clean --force \
    && npm install \
	&& npm run build \
	&& apt-get purge -y git python make g++ \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists /var/log /usr/share/man /tmp /var/tmp

ENV HOST 0.0.0.0
EXPOSE 80

CMD ["npm","run","start"]