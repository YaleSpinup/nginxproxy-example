#!/bin/bash
# vim: set ts=8 tw=0 noet :

set -e -o pipefail

cert_expire=${CERT_EXPIRE:-3650}
cert_size=${CERT_SIZE:-rsa:2048}
cert_subject=${CERT_SUBJECT:-/CN=localhost}
backend_url=${BACKEND_URL:-http://127.0.0.1:8080}
listen_port=${LISTEN_PORT:-8443}
server_tokens=${SERVER_TOKENS:-off}
ssl_protocols=${SSL_PROTOCOLS:-"TLSv1.2 TLSv1.3"}

echo "Generating SSL Certificate with expire: ${cert_expire}, size: ${cert_size}, subject: ${cert_subject}..."

openssl req -x509 -nodes -days "${cert_expire}" -newkey "${cert_size}" -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt  -subj "${cert_subject}"

echo "Configuring NGINX Proxy with listen port: ${listen_port}, backend url: ${backend_url}..."

cat << EOF > /etc/nginx/sites-available/default
server {
  listen ${listen_port} ssl http2;
  server_tokens ${server_tokens};
  ssl_certificate /etc/nginx/cert.crt;
  ssl_certificate_key /etc/nginx/cert.key;

  # Addressing TLS and cipher issues
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_prefer_server_ciphers on;
  ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;

  # HSTS (HTTP Strict Transport Security)
  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

  # X-Content-Type-Options header
  add_header X-Content-Type-Options nosniff;

  # X-Frame-Options to help prevent clickjacking
  add_header X-Frame-Options SAMEORIGIN;

  # X-XSS-Protection
  add_header X-XSS-Protection "1; mode=block";

  location / {
    proxy_ssl_session_reuse on;

    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;

    proxy_pass ${backend_url};

    # Secure cookie flag
    proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
  }
}
EOF

echo 'Starting up...'
