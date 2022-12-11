#FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.14
FROM linuxserver/heimdall:2.5.4

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache --upgrade php8-phar && \
 curl -s https://getcomposer.org/installer | php && \
 echo "**** link /vendor to heimdall vendor folder ****" && \
 mkdir /var/www/localhost/heimdall/vendor && \
 ln -s /var/www/localhost/heimdall/vendor /vendor && \
 echo "**** install composer ****" && \
 curl -s https://getcomposer.org/installer | php && \
 echo "**** install oidc plugin ****" && \
 php /composer.phar require vizir/laravel-keycloak-web-guard --update-with-dependencies --with-all-dependencies

# add local files
COPY root/etc/cont-init.d/60-config-keycloak /etc/cont-init.d/

