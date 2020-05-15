# nginxproxy

**NOTE:** *This is an example of how one could build a sidecar proxy to provide an encrypted endpoint to front an application and should probably be customized for your use case!*

Example `nginx` SSL proxy that generates a self signed cert on startup and starts listening on the wire.  Connections are proxied to a backend service, by default this is `http://127.0.0.1:8080`.

## Author

E Camden Fisher <camden.fisher@yale.edu>

## License

GNU Affero General Public License v3.0 (GNU AGPLv3)
Copyright (c) 2020 Yale University
