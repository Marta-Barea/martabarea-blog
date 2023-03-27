vcl 4.0;

import std;

backend default {
    .host = "localhost";
    .port = "443";
    .ssl = true;
}

acl purge {
    "localhost";
    "127.0.0.1";
}

sub vcl_recv {
    # Set the backend to use
    set req.backend_hint = default;

    # Set the host header for the backend
    set req.http.host = req.http.x-forwarded-host || req.http.host;

    # Strip query string from request
    set req.url = std.querysort(req.url);

    # Serve from cache if possible
    if (req.method == "GET" && req.http.cookie !~ "loggedin") {
        if (req.url ~ "^/static/") {
            # Serve static files directly
            return (hash);
        } else {
            # Serve dynamic content from cache if possible
            return (hash);
        }
    }

    # Purge cached content if requested
    if (req.method == "PURGE") {
        if (!client.ip ~ purge) {
            return (synth(405, "Method not allowed"));
        }
        return (purge);
    }

    # Pass non-cacheable requests to the backend
    return (pass);
}

sub vcl_backend_response {
    # Set cache control headers for static files
    if (bereq.url ~ "^/static/") {
        set beresp.ttl = 7d;
        set beresp.http.cache-control = "max-age=604800, public";
        set beresp.http.expires = std.time2http(now + 7d);
    } else {
        set beresp.ttl = 1m;
        set beresp.http.cache-control = "max-age=60, private";
        set beresp.http.expires = std.time2http(now + 1m);
    }
}

sub vcl_deliver {
    # Set CORS headers
    if (req.http.origin) {
        set resp.http.access-control-allow-origin = req.http.origin;
        set resp.http.access-control-allow-credentials = "true";
    }
}