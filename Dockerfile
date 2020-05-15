FROM debian:stable-slim

ENV CERT_SIZE rsa:2048
ENV CERT_EXPIRE 3650
ENV CERT_SUBJECT /CN=localhost
ENV BACKEND_URL http://127.0.0.1:8080

EXPOSE 8443

RUN apt-get -y update && \
    apt-get -y install nginx openssl && \
    rm -rf /var/lib/apt/lists/*

COPY config.sh /

# ENTRYPOINT /bin/bash -x /config.sh && nginx -g 'daemon off;' 
ENTRYPOINT ["/bin/bash", "-c", "/config.sh && nginx -g 'daemon off;'"]