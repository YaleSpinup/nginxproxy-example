# nginxproxy

**NOTE:** *This is an example of how one could build a sidecar proxy to provide an encrypted endpoint to front an application and should probably be customized for your use case!*

`nginx` SSL proxy that generates a self signed cert on startup and starts listening on the wire.  Connections are proxied to a backend service, by default this is `http://127.0.0.1:8080`.  The backend service can be overridden with an environment variable, as can the listen port for the proxy.

The following environment variables will customize the runtime:

| Variable     | Default               | Description                          |
|--------------|-----------------------|--------------------------------------|
| CERT_EXPIRE  | 3650                  | Number of days until cert expiration |
| CERT_SIZE    | rsa:2048              | Size of the proxy certificate        |
| CERT_SUBJECT | /CN=localhost         | CN for the certificate               |
| BACKEND_URL  | http://127.0.0.1:8080 | Backend URL to proxy connections     |
| LISTEN_PORT  | 8443                  | Proxy listen port                    |

## Author

E Camden Fisher <camden.fisher@yale.edu>

## License

GNU Affero General Public License v3.0 (GNU AGPLv3)  
Copyright (c) 2020 Yale University
