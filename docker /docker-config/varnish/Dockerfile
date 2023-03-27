FROM varnish:6.0.11

COPY ./docker/docker-config/varnish/default.vcl /etc/varnish/default.vcl

CMD ["varnishd", "-F", "-f", "/etc/varnish/default.vcl"]