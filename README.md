PlugCors
========

A CORS Plug

Usage:

```
    plug PlugCors, origins: ["test.origin.test", "*.domain.com"], methods: ["GET", "POST"], headers: ["Authorization"]
```

Parameters:

* origins: A list of allowed origins or "\*" for all origins. Default: "\*". Can add use wildcards domains such as "*.domain.com" to match on the domain and all it's sub domains

* methods: A list of allowed HTTP methods. Default: ["GET", "HEAD", "POST", "OPTIONS", "PUT", "PATCH", "DELETE"]

* headers: A list of allowed HTTP headers. Default: [] ( allow any headers)

* expose_headers: A list of headers to expose to the browser via the "Access-Control-Expose-Headers" header. Default: [] (Will not output header)

* max_age: The max cache age of the response in seconds "Access-Control-Max-Age" header. Default: 0 (Will not output header)

* supports_credentials: Whether or not to allow cookies with requests "Access-Control-Allow-Credentials" header. Default: false (Will not output header)



