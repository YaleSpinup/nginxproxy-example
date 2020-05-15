#!/bin/bash
# vim: set ts=8 tw=0 noet :

set -e -o pipefail

echo 'Generating SSL Certificate...'
openssl req -x509 -nodes -days "${CERT_EXPIRE}" -newkey "${CERT_SIZE}" -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt  -subj "${CERT_SUBJECT}"

echo 'Configuring NGINX Proxy...'
cat << EOF > /etc/nginx/sites-available/default
server {
  listen 8443;
  ssl on;
  ssl_certificate /etc/nginx/cert.crt;
  ssl_certificate_key /etc/nginx/cert.key;
  location / {
     proxy_pass ${BACKEND_URL};
  }
}
EOF

echo 'Starting up...'