FROM debian:stable-slim

EXPOSE 8443

RUN apt-get -y update && \
    apt-get -y install nginx openssl && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY config.sh /

ENTRYPOINT ["/bin/bash", "-c", "/config.sh && nginx -g 'daemon off;'"]