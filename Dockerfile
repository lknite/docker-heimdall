#FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.14
FROM linuxserver/heimdall:2.5.4

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache --upgrade \
   php8-phar \
   php8-xml && \
 curl -s https://getcomposer.org/installer | php && \
 echo "**** install composer ****" && \
 curl -s https://getcomposer.org/installer | php
# echo "**** install oidc plugin ****" && \
# php /composer.phar -d /var/www/localhost/heimdall/vendor require vizir/laravel-keycloak-web-guard --update-with-dependencies --with-all-dependencies

# add local files
COPY root/etc/cont-init.d/60-config-keycloak /etc/cont-init.d/

# echo "**** link /vendor to heimdall vendor folder ****" && \
# mkdir /var/www/localhost/heimdall/vendor && \
# ln -s /var/www/localhost/heimdall/vendor /vendor && \
