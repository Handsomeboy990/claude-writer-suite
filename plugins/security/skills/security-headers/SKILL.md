---
name: security-headers
description: Configures and audits the HTTP response headers and transport settings that harden a web application in the browser: Content-Security-Policy, HSTS, X-Content-Type-Options, frame protection, Referrer-Policy, Permissions-Policy, CORS, and cookie security flags. Turns the browser into an ally instead of an open door. Use when building or reviewing any web response, an API's CORS, or a content-security-policy.
license: MIT
metadata:
  category: secure-development
  version: 1.0.0
  depends_on: [security-core]
  outputs: [header-policy, header-findings, csp, cors-policy, applied-fixes]
---

# Security Headers

A browser will do exactly what a page tells it to, including running injected
script and framing the page inside an attacker's site, unless the response
headers tell it not to. These headers are cheap to set and close whole classes
of attack in the client. Missing them is a finding; misconfiguring them is worse
than missing them, because it looks like protection.

## 1. Content-Security-Policy

The strongest and the hardest. CSP tells the browser which sources of script,
style, image and connection are allowed, so an injected script from anywhere
else does not run.

```
goal        no inline script, no eval, scripts from a named allowlist or a nonce
start       report-only first, collect violations, tighten, then enforce; a CSP
            enforced blind breaks the app and gets disabled
nonce       a per-response nonce on legitimate script tags beats a host
            allowlist, which is often bypassable
avoid       unsafe-inline and unsafe-eval defeat the purpose; a policy with both
            is theatre
default-src  set a restrictive default, then open specific directives, so a
            directive nobody set inherits the restriction
```

A real CSP is the single most effective control against XSS, and the one most
often shipped in a form that does nothing. Rank a policy that includes
unsafe-inline for script as barely better than absent.

## 2. Transport: HSTS

```
HSTS        Strict-Transport-Security tells the browser to use HTTPS only for
            this host, so a downgrade or an sslstrip fails
max-age     long, once the site is confidently HTTPS-only; a long max-age on a
            site that still needs HTTP is a self-inflicted outage
subdomains  includeSubDomains only when every subdomain is HTTPS
preload     the preload list is effectively irreversible; opt in deliberately
```

## 3. The cheap, unambiguous headers

```
X-Content-Type-Options: nosniff   the browser does not guess a response's type,
                                  which closes MIME-confusion attacks
X-Frame-Options / frame-ancestors   the page cannot be framed by another site,
                                  which closes clickjacking; frame-ancestors in
                                  CSP is the modern form
Referrer-Policy                   controls how much of the URL leaks to other
                                  sites; strict-origin-when-cross-origin is a
                                  safe default
Permissions-Policy                disables browser features the app does not use:
                                  camera, microphone, geolocation, so an
                                  injection cannot reach them
```

These have no downside and one correct value each. Their absence is a finding
with a trivial fix.

## 4. CORS: the header that is usually too open

CORS decides which other origins may read a response. It is repeatedly set to
allow everything, which removes the protection entirely.

```
never        Access-Control-Allow-Origin: * together with credentials; the
             browser forbids it, and code that tries is confused about the model
allowlist    reflect a specific, checked origin from a known list; never reflect
             the request's Origin header unchecked, which is the same as *
methods      allow only the methods the endpoint serves
credentials  Allow-Credentials true only for a specific origin, never with *
preflight    handle OPTIONS correctly; a wrong preflight either breaks the app
             or opens it
```

A wildcard CORS on an authenticated API is a high finding: any site can make the
user's browser read their data.

## 5. Cookies

The session cookie flags belong to `session-security`; this skill confirms they
are present on every cookie that carries anything sensitive.

```
HttpOnly, Secure, SameSite   on every cookie that matters, per session-security
```

## 6. Verifying, not just setting

```
inspect     read the actual response headers from a running instance, not the
            framework config that is supposed to set them; a proxy or a CDN may
            strip or add headers
every path  the headers on the login page, the API, the error page and the
            static assets; a header set on one route and missing on another is
            a gap
report      wire CSP violation reporting so a real policy is measured, not
            assumed
```

## 7. Prohibitions

- Never ship a CSP with unsafe-inline or unsafe-eval on script and call it
  protection.
- Never enforce a new CSP without a report-only phase; it breaks the app and
  gets removed.
- Never set Access-Control-Allow-Origin to * on anything authenticated.
- Never reflect the request Origin into the allow-origin header unchecked.
- Never set a long HSTS max-age or preload before the site is confidently
  HTTPS-only.
- Never trust the framework config; verify the headers on the live response.

## 8. Protocol

1. Inventory the current response headers from a running instance, every route
   type.
2. Design a CSP: restrictive default, nonce for legitimate script, no unsafe-*;
   deploy report-only, collect, tighten, enforce.
3. Set HSTS to the site's real HTTPS posture.
4. Set nosniff, frame protection, Referrer-Policy and Permissions-Policy.
5. Lock CORS to a checked allowlist; never wildcard with credentials.
6. Confirm sensitive cookies carry the session-security flags.
7. Verify every header on the live response across routes; rank gaps.
8. Fix what config fixes; hand CDN or proxy header handling to the
   infrastructure list.

## 9. Auto-critique

Score from 0 to 5: CSP restrictive without unsafe-* on script and rolled out via
report-only, HSTS matched to the HTTPS posture, nosniff and frame protection and
Referrer-Policy and Permissions-Policy set, CORS an checked allowlist with no
credentialed wildcard, sensitive cookies flagged, headers verified on the live
response rather than assumed from config.

Threshold: no axis below 3, average at least 4. A credentialed wildcard CORS, or
a CSP that is pure theatre, caps the score until fixed.

## 10. Interfaces

- Upstream: `security-core`, `security-architecture` for the transport posture,
  `api-design` for the CORS surface of an API.
- Downstream: `security-audit` verifies the headers in the sweep, `deployment-
  engineering` and `infrastructure-as-code` place headers set at the proxy or
  CDN.
- Lateral: `session-security` owns the cookie flags this skill confirms,
  `frontend-engineering` adapts to the CSP by removing inline script.
