## Dockerfile for Apache 2.4.20 on CentOS 7

### Pull image

```shell
$ docker pull edwardjkim/httpd
```

### Configuration

To customize the configuration of the httpd server, just `COPY` your custom
configuration in as `$HTTPD_PREFIX/conf/httpd.conf`.

```
FROM edwardjkim/httpd
COPY ./my-httpd.conf $HTTPD_PREFIX/conf/httpd.conf
```

### SSL/HTTPS

If you want to run your web traffic over SSL, the simplest setup is to `COPY`
or mount (`-v`) your `server.crt` and `server.key` into `$HTTPD_PREFIX/conf/`
and then customize the `$HTTPD_PREFIX/conf/httpd.conf` by removing the comment
from the line with `#Include conf/extra/httpd-ssl.conf`. This config file will
use the certificate files previously added and tell the daemon to also listen
on port 443. Be sure to also add something like -p 443:443 to your docker run
to forward the https port.

