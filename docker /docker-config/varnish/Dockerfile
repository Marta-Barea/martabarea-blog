FROM varnish:6.0.11

COPY default.vcl /etc/varnish/default.vcl

CMD ["varnishd", "-F", "-f", "/etc/varnish/default.vcl"]