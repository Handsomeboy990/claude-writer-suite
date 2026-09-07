# Security header reference

The headers to set on a web response, the correct value, what it closes, and the
severity when it is absent or wrong. Verify each on the live response, not in the
framework config.

| Header | Correct value | Closes | Missing / wrong |
|---|---|---|---|
| Content-Security-Policy | restrictive default-src, nonce for script, no unsafe-* | XSS execution, data exfiltration | high; theatre if unsafe-inline on script |
| Strict-Transport-Security | max-age long, once HTTPS-only | downgrade, sslstrip | medium; outage if set too early |
| X-Content-Type-Options | nosniff | MIME-confusion attacks | low, trivial to fix |
| X-Frame-Options / frame-ancestors | DENY / 'none' unless framing is needed | clickjacking | medium |
| Referrer-Policy | strict-origin-when-cross-origin | URL leakage to other sites | low |
| Permissions-Policy | disable unused features (camera, mic, geolocation) | injected access to device features | low |
| Access-Control-Allow-Origin | a checked allowlist, never * with credentials | cross-origin data theft | high if wildcard + credentials |

## CORS decision tree

```
Is the endpoint authenticated (cookies or credentials)?
  yes -> Allow-Origin must be a single checked origin, never *
         Allow-Credentials: true only with that specific origin
  no  -> * is acceptable for a genuinely public, non-sensitive resource

Do you reflect the request's Origin header?
  only after checking it against an allowlist; reflecting it unchecked is *
```

## The verification step

For each header above:
1. Request the live URL and read the actual response headers.
2. Repeat for the login page, the API, an error response, and static assets.
3. A header present on one route and absent on another is a gap, not a pass.
4. A proxy or CDN may add or strip headers; the live response is the truth, not
   the application config.
