# Control Center evolution

This document describes the Control Center after the analytics, advisor,
localization, reporting and UX work. It records the current architecture, what
is real, what is deliberately not built, and the extension points that let the
missing telemetry be added later without another rewrite.

## Principles that did not change

- Zero dependency. Python standard library and one self-contained HTML file. No
  pip, no npm, no build step.
- Local first. The server binds to `127.0.0.1` only and opens no outbound
  connection.
- Real data only. Every figure is read from local files. A metric that cannot
  be established is shown as unavailable, never as a fabricated number or a
  misleading zero.

## Data flow

```
Local session transcripts (~/.claude/projects/*/*.jsonl)
Installed skills and agents directories
Configuration file (no secrets)
        |
        v
reader.py  (parse and aggregate, standard library only)
        |     produces: totals, overview, per-session, per-project, per-day,
        |     tools, skills, models, and per-session evidence for the advisor
        v
advisor.py (pure, deterministic analysis of the evidence)
        |     produces: optimization score, findings, patterns, opportunities
        v
server.py  (loopback HTTP; GET /api/data merges reader + advisor)
        |
        v
app.html   (single page: dashboard, sessions, analytics, optimization, usage,
            projects, skills, health, privacy; i18n EN/FR; exports)
```

The command line uses the same `reader.py` and `advisor.py`: `install.sh
--report` prints a text summary including the optimization findings, and
`python3 control-center/reader.py --json` dumps the full data.

## What is real, and where it comes from

| Metric | Source | Notes |
|---|---|---|
| sessions, tokens, models, tools | assistant records in the transcripts | real recorded usage |
| fresh input, cache read, cache creation, output | the `usage` object of each assistant message | shown as four separate components |
| work tokens | fresh input plus output | excludes cache re-reads, which would otherwise dominate every figure |
| per-session file reads and edits | the `file_path` of Read/Edit/Write tool calls | counts only, no file is opened |
| repeated command shapes | the first tokens of Bash `command` inputs | a coarse signature groups near-identical commands |
| large outputs | per-message output token counts above a documented threshold | a count to surface, never a judgement |
| installed skills and agents | listing the target directories | a listing, not an inference |
| configuration | the config file | credential-shaped keys dropped as defence in depth |

The token headline separates the four components on purpose. Cache reads are the
same context re-read cheaply on every turn and sum to billions; folding them into
one "input" number would misrepresent usage. Session sizes and the overview use
work tokens (fresh input plus output) so they are comparable.

## The optimization advisor

`advisor.py` turns the per-session evidence into findings. It is pure and
deterministic: same input, same output, no I/O, no randomness.

### Detection, all evidence-based

| Category | Signal | Severity |
|---|---|---|
| repeated-exploration | a file read >= 3 times in a session | low, medium at >= 6 |
| edit-churn | a file edited >= 4 times | low, medium at >= 8 |
| command-repetition | a command shape repeated >= 5 times | low, medium at >= 30 |
| low-cache-reuse | cache reuse ratio < 0.5 with meaningful cache created | low |
| large-output | >= 3 outputs above the large-output threshold | informational |
| broad-scope | one session with many messages, tool types and files together | medium |
| missing-project-context | a project explored from scratch in >= 3 sessions | medium (aggregate) |

Each threshold is a floor: below it, no finding is raised, because the evidence
is insufficient. A session with no qualifying signal produces no findings and a
perfect score. The advisor never invents a finding, and it never asserts that a
pattern caused waste; it states what happened and what could reduce repetition.

### Scoring, stated exactly

Every analysed session starts at 100. Each finding subtracts its severity
penalty: critical 25, high 15, medium 8, low 4, informational 1. The session
score is floored at 0. The overall optimization score is the integer mean of the
session scores. With no analysable sessions the score is null, not 100, because
absence of data is not evidence of efficiency.

The scoring, thresholds and method string are returned in the data and shown in
the Optimization tab's Methodology panel, so the number is explainable and
reproducible.

## Localization

Strings live in one place: the `I18N` dictionary in `app.html`, with English and
French, English as the fallback. Advisor findings are localized through the
`FINDINGS_I18N` templates, which interpolate the real evidence values the advisor
returns. The advisor itself holds no user-facing prose, so a new language is a
dictionary addition with no change to the analysis. Language is switched live and
persisted in `localStorage`.

## Theme

Colours are CSS custom properties defined for light and dark, resolved three
ways: an explicit `data-theme` attribute wins, otherwise `prefers-color-scheme`
decides. The toggle persists the choice in `localStorage`. Charts and severity
colours are variables too, so both themes are complete.

## Reporting and export

Reports are generated client-side from the loaded data, so no new server-side
file writing is introduced. Formats: JSON (the report object), CSV (the session
table), HTML (a standalone styled document), and PDF through the browser's own
print dialog on a print-styled report. The PDF path is a genuine PDF produced by
the browser, not a renamed HTML file, and it needs no external dependency. Every
value interpolated into the HTML report is escaped.

Each report states its period, generation time, data sources, the metrics used,
the data limitations and a privacy note, so it is explainable and reproducible.

## Privacy and security

- The server binds to loopback only and serves a fixed set of routes; it never
  maps a request path to the filesystem, so path traversal has no surface.
- The one POST endpoint reports that the Control Center keeps no store of its
  own; it writes nothing.
- Reports are built and downloaded in the browser from already-loaded data.
- HTML report generation escapes every interpolated value; the live UI builds
  text nodes rather than HTML, so project names and file paths cannot inject
  markup.

## What is deliberately not built

The following are not collected by the current data source and are therefore not
shown, rather than estimated:

- agent-level usage (which agent ran, how often)
- skill usage beyond explicit `Skill`-tool calls
- external resources consulted (URLs, documents, repositories)
- quality-audit or security-audit results

These are named as unavailable in the interface. The architecture leaves clean
extension points for them:

```
reader.py evidence collection
    |
    +-- session token and message aggregation      (implemented)
    +-- file access and command evidence            (implemented)
    +-- future agent telemetry                      (add a collector, extend the session evidence)
    +-- future skill telemetry                      (extend the skills counter)
    +-- future resource telemetry                   (add a collector)
        |
        v
advisor.py     (add a detection function per new signal)
app.html       (add a tab or panel and its i18n keys)
```

Adding a new telemetry source is a new collector in `reader.py`, an optional new
detection in `advisor.py`, and a panel with its translations in `app.html`. None
of it requires changing the existing pipeline.

## Testing

- `control-center/test_advisor.py`: deterministic fixtures covering empty data,
  clean sessions, every finding category, the below-threshold no-invention case,
  the scoring formula, the floor at 0, cross-session logic and determinism.
- The CI parses `reader.py`, `server.py` and `advisor.py`, runs the advisor
  tests, extracts the `app.html` script and checks its syntax, and runs the
  reader and advisor CLIs.
- Browser verification with Playwright covers every tab, the session detail
  modal, the export dialog, the theme and language toggles, light and dark,
  desktop, tablet and mobile widths, with no console errors and no horizontal
  overflow.
