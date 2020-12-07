#!/bin/bash
# vim: set ts=8 tw=0 noet :

set -e -o pipefail

cert_expire=${CERT_EXPIRE:-3650}
cert_size=${CERT_SIZE:-rsa:2048}
cert_subject=${CERT_SUBJECT:-/CN=localhost}
backend_url=${BACKEND_URL:-http://127.0.0.1:8080}
listen_port=${LISTEN_PORT:-8443}

echo "Generating SSL Certificate with expire: ${cert_expire}, size: ${cert_size}, subject: ${cert_subject}..."

openssl req -x509 -nodes -days "${cert_expire}" -newkey "${cert_size}" -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt  -subj "${cert_subject}"

echo "Configuring NGINX Proxy with listen port: ${listen_port}, backend url: ${backend_url}..."

cat << EOF > /etc/nginx/sites-available/default
server {
  listen ${listen_port};
  server_tokens off;
  ssl on;
  ssl_certificate /etc/nginx/cert.crt;
  ssl_certificate_key /etc/nginx/cert.key;
  ssl_protocols TLSv1.2 TLSv1.3;
  location / {
    proxy_ssl_session_reuse on;

    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;

    proxy_pass ${backend_url};
  }
}
EOF

echo 'Starting up...'
