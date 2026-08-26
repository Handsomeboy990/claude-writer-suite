# Session cookie attributes reference

Each attribute closes a specific attack. A session cookie sets all of the
applicable ones; a missing attribute is a finding at the severity noted.

| Attribute | Value | Closes | Missing = |
|---|---|---|---|
| HttpOnly | present | script reading the cookie (XSS -> session theft) | high |
| Secure | present | the cookie sent over plain HTTP | high |
| SameSite | Lax or Strict | most CSRF at the transport layer | high if no CSRF token |
| Max-Age / Expires | bounded | a cookie outliving its session | medium |
| Path | narrowest that works | sharing with unrelated paths | low |
| Domain | the exact host, not a parent | sharing with sibling subdomains | medium |
| __Host- prefix | on the name | domain/path relaxation, host confusion | low, defence in depth |

## Worked example

```
Set-Cookie: __Host-session=<high-entropy-id>;
            HttpOnly;
            Secure;
            SameSite=Lax;
            Path=/;
            Max-Age=28800
```

- `__Host-` requires Secure, Path=/, and no Domain, and binds the cookie to the
  exact host.
- `SameSite=Lax` sends the cookie on top-level navigation but not on cross-site
  subrequests, which is the common CSRF vector.
- `SameSite=Strict` is tighter but breaks inbound links that expect a session;
  choose Lax unless the flow tolerates Strict.
- `Max-Age=28800` is the absolute session ceiling in seconds (8 hours here),
  matched to the asset.

## The check

For every Set-Cookie that carries a session, confirm HttpOnly and Secure are
present, SameSite is set, and the lifetime is bounded. A bearer token in local
storage has none of these protections and is a design choice to question, not a
cookie to configure.
