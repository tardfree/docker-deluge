FROM alpine:edge
LABEL maintainer="robert@splat.cx" description="basic deluge container" 

RUN \
	apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
		ca-certificates \
		openssl \
		deluge && \

# basic
	mkdir -p /config /downloads && \

####### package has missing/broken dependencies;
## fix due to bug: https://bugs.alpinelinux.org/issues/7154
	apk add --no-cache --virtual=.build-env \
		py2-pip \
		python2-dev \
		gcc \
		g++ && \

	pip install --no-cache-dir -U \
		incremental \
		service_identity \
		twisted \
		pip && \

	apk del --purge .build-env && \
## end fix
#######

# add user
	addgroup -g 1000 deluge && \
	adduser -H -D -G deluge -s /bin/false -u 1000 deluge && \

# permissions
	chown -R deluge:deluge /config /downloads && \

# cleanup
	rm -rf /tmp/*

COPY apprun.sh /app/apprun.sh

# volume mappings
VOLUME /config /downloads
EXPOSE 8112 58332 58846
#8112=web port
#58332=BT port
#58846=webui - daemon port

USER deluge
ENTRYPOINT ["/app/apprun.sh"]
