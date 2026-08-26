# Example: rolling out a Content-Security-Policy without breaking the app

A dashboard app with no CSP. XSS is the top threat from its model. A CSP is the
strongest control, and the one most likely to break the app if enforced blind.
So it is rolled out in phases.

## Phase 1: measure with report-only

Deploy the intended policy as report-only. It blocks nothing; it reports what it
would block.

```
Content-Security-Policy-Report-Only:
  default-src 'self';
  script-src 'self' 'nonce-<per-response>';
  style-src 'self';
  img-src 'self' data:;
  connect-src 'self' https://api.example.com;
  frame-ancestors 'none';
  report-uri /csp-report
```

## Phase 2: read the violation reports

```
violation  inline script on the settings page (an onclick handler)
violation  a Google Fonts stylesheet from fonts.googleapis.com
violation  an inline style attribute on three components
```

Each violation is either a legitimate resource to allowlist, or an inline
pattern to remove. The onclick handlers are moved to attached listeners; the
font stylesheet is added to style-src; the inline style attributes are moved to
classes.

## Phase 3: tighten and enforce

After the app produces zero violations in report-only for a week, switch the
header from report-only to enforcing. The policy now blocks any script the app
did not intend, which is the XSS defence.

```
Content-Security-Policy:
  default-src 'self';
  script-src 'self' 'nonce-<per-response>';
  style-src 'self' https://fonts.googleapis.com;
  font-src https://fonts.gstatic.com;
  img-src 'self' data:;
  connect-src 'self' https://api.example.com;
  frame-ancestors 'none';
  report-uri /csp-report
```

## Verification

```
inject a <script> via a stored field   the browser refuses to run it (blocked by CSP)
the app's own nonced scripts            run normally
the report endpoint                     continues to catch anything new
```

## Why the phasing mattered

Enforcing the phase-3 policy on day one would have broken the settings page and
the fonts, and the fix under pressure is almost always to add unsafe-inline,
which removes the entire protection. Report-only turned a breaking change into a
measured one, and produced a policy with no unsafe-* on script, which is a real
XSS control rather than a header that looks like one.
