FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.14

# set version label
ARG BUILD_DATE
ARG VERSION
ARG HEIMDALL_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache --upgrade \
	curl \
	php7-ctype \
	php7-curl \
	php7-pdo_pgsql \
	php7-pdo_sqlite \
	php7-pdo_mysql \
	php7-tokenizer \
	php7-zip \
	php7-phar && \
 echo "**** link /vendor to heimdall vendor folder ****" && \
 mkdir /var/www/localhost/heimdall && \
 mkdir /var/www/localhost/heimdall/vendor && \
 ln -s /var/www/localhost/heimdall/vendor /vendor && \
 echo "**** install composer ****" && \
 curl -s https://getcomposer.org/installer | php && \
 echo "**** install oidc plugin ****" && \
 php /composer.phar require vizir/laravel-keycloak-web-guard --update-with-dependencies --with-all-dependencies && \
 echo "**** install heimdall ****" && \
 mkdir -p \
	/heimdall && \
 if [ -z ${HEIMDALL_RELEASE+x} ]; then \
	HEIMDALL_RELEASE=$(curl -sX GET "https://api.github.com/repos/linuxserver/Heimdall/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 /heimdall/heimdall.tar.gz -L \
	"https://github.com/linuxserver/Heimdall/archive/${HEIMDALL_RELEASE}.tar.gz" && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /
