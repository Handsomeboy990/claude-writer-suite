# Report templates

Markdown first. HTML only when the audience is outside the team and the
evidence must travel with the document.

## Markdown campaign report

```markdown
# Test report: <product>, <campaign name>

Verdict: PASS WITH WARNINGS
One critical defect found and fixed, two medium findings accepted for the next
release, cross browser coverage incomplete on Safari.

## Scope

| | |
|---|---|
| Environment | staging, https://staging.example.com |
| Build | 4c17ab9 |
| Dates | 2026-08-03 to 2026-08-07 |
| Disciplines | api, browser, exploratory, accessibility, security, reliability |
| Not in campaign | performance, no threshold stated. Load testing, out of scope. |
| Roles used | owner, admin, member, viewer, anonymous, second tenant |

## Metrics

| | |
|---|---|
| Automated tests executed | 341 of 341, 338 passed, 3 failed, 0 skipped |
| Endpoints exercised | 38 of 41, 3 excluded, listed in section 6 |
| Journeys exercised | 7 of 7 |
| Accessibility criteria | 31 checked manually, 12 automated, 5 not applicable |
| Findings | 1 critical, 3 high, 4 medium, 6 low, 2 info |
| Fixed during campaign | 4, each retested |
| Suite stability | 2 consecutive identical runs |

## Findings

### Critical

#### BUG-01 Tenant isolation missing on the documents API
<the full finding record>

### High
<...>

### Medium and below

| ID | Severity | Title | Status |
|---|---|---|---|
| BUG-08 | Medium | Order table overflows at 360 px | open |

## What passed

- invitation, signup and first document, end to end, all four roles
- payment capture, refund and reconciliation under a provider timeout
- session expiry, revocation and role change propagate immediately
- keyboard operation of the three critical journeys, focus returned correctly
- 341 automated tests, stable across two runs

## Not covered

- Safari and iOS Safari: no runner available. Untested, not assumed working.
- performance: no thresholds exist. Measured values in appendix B, reported
  rather than judged.
- the admin billing screens: out of scope by contract.

## Evidence

| Reference | Artefact |
|---|---|
| BUG-01 | evidence/findings/BUG-01-cross-tenant.png |

## Recommendation

Ship, with the two medium findings scheduled. Safari coverage is the one
material gap and should be closed before the next release.
```

## HTML report

Self contained: one file, styles inline, images embedded or beside it in the
evidence directory. No external stylesheet, no font from a network, no script
that fetches anything. It must open correctly from a file system, offline,
years later.

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Test report: <product>, <campaign></title>
  <style>
    :root { --bg:#fff; --fg:#1a1a1a; --muted:#5a5a5a; --line:#e0e0e0;
            --crit:#8b1a1a; --high:#a34400; --med:#7a6a00; --low:#31572c; }
    body { margin:0 auto; max-width:70rem; padding:2rem 1.25rem;
           font:16px/1.6 system-ui, sans-serif; color:var(--fg);
           background:var(--bg); }
    h1,h2,h3 { line-height:1.25; }
    table { border-collapse:collapse; width:100%; margin:1rem 0; }
    th,td { border:1px solid var(--line); padding:.5rem .625rem;
            text-align:left; vertical-align:top; }
    .verdict { border-left:6px solid var(--high); padding:.75rem 1rem;
               background:#faf7f2; }
    .finding { border:1px solid var(--line); border-radius:6px;
               padding:1rem; margin:1rem 0; }
    .sev { font-weight:700; text-transform:uppercase; font-size:.8rem; }
    .sev-critical { color:var(--crit); } .sev-high { color:var(--high); }
    .sev-medium { color:var(--med); }   .sev-low { color:var(--low); }
    figure { margin:1rem 0; } figure img { max-width:100%; border:1px solid var(--line); }
    figcaption { color:var(--muted); font-size:.875rem; }
    pre { overflow-x:auto; background:#f6f6f6; padding:.75rem; border-radius:4px; }
    @media (prefers-color-scheme: dark) {
      :root { --bg:#151515; --fg:#ececec; --muted:#a8a8a8; --line:#333; }
      pre { background:#1e1e1e; } .verdict { background:#1e1b17; }
    }
  </style>
</head>
<body>
  <h1>Test report</h1>
  <p class="verdict"><strong>PASS WITH WARNINGS.</strong> One critical defect
     found and fixed. Safari not covered.</p>

  <h2>Scope</h2>
  <table><tbody>
    <tr><th>Environment</th><td>staging</td></tr>
    <tr><th>Build</th><td>4c17ab9</td></tr>
  </tbody></table>

  <h2>Findings</h2>
  <section class="finding">
    <p class="sev sev-critical">Critical</p>
    <h3>BUG-01 Tenant isolation missing on the documents API</h3>
    <p><strong>Steps.</strong> ...</p>
    <p><strong>Expected.</strong> ... <strong>Actual.</strong> ...</p>
    <figure>
      <img src="evidence/findings/BUG-01-cross-tenant.png"
           alt="Response returning a document owned by another tenant">
      <figcaption>Status line and first response field only. Body redacted.</figcaption>
    </figure>
  </section>

  <h2>What passed</h2>
  <h2>Not covered</h2>
  <h2>Recommendation</h2>
</body>
</html>
```

Requirements for the HTML form:

```
one file, no network dependency, opens offline
every image has real alternative text describing what it proves
severity conveyed by text as well as by colour
readable in light and dark
tables scroll rather than breaking the page on a narrow screen
no credential, token or personal data anywhere, including in screenshots
```

## Short form, for a chat or a pull request comment

```
Status: PASS WITH WARNINGS
Env: staging 4c17ab9

Tests: 341 executed, 338 passed, 3 failed
Findings: 1 critical (fixed), 3 high (fixed), 4 medium, 6 low
Security: cross tenant read on 5 routes, fixed and retested
Accessibility: 3 blocking, 2 fixed, 1 scheduled
Reliability: record without file on storage outage, fixed
Regression: impact set plus critical set, green
Not covered: Safari, performance thresholds

Full report: docs/qa/2026-08-07-report.md
```
