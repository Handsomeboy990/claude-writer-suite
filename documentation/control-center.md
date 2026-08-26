# Control Center

An optional local dashboard for the suite. It reads the session data, installed
skills, agents and configuration that already exist on the machine, and shows
them: usage, tokens, models, tools, skills, projects and system health.

It is optional. Every skill works without it, and nothing about installing,
configuring or using a skill depends on it.

## Design constraints

The repository's premise is that it has no dependencies: Markdown and shell. The
Control Center holds to that.

- Zero dependency. Python 3 standard library and one HTML file. No `pip install`,
  no `npm install`, no build step, no lockfile, no `node_modules`.
- Local first. The server binds to `127.0.0.1` only, never to a public
  interface. It opens no outbound connection.
- Honest. Every figure is read from local files. Token counts are the real usage
  figures recorded in the transcripts. A metric that cannot be established is
  shown as unavailable, never invented.

## Running it

```bash
bash install.sh --control-center
```

It finds a free port in a dedicated range starting at 7317, chosen to avoid the
common development ports (3000, 5173, 8000, 8080 and the like), prints the URL,
and opens the browser. Stop it with Ctrl-C.

```bash
bash install.sh --control-center --no-browser     # do not open a browser
bash install.sh --control-center --port 7400       # request a specific port
```

A port is never assumed free; the binding is attempted, and the next free port
in the range is used if the first is taken.

## The terminal report

For the same figures without a browser:

```bash
bash install.sh --report                  # a text summary
python3 control-center/reader.py --json   # the full data as JSON
```

## What it reads, and how honestly

| Source | Produces | Honesty |
|---|---|---|
| session transcripts | sessions, tokens, models, tools, skill invocations, per-project and per-day breakdowns | real recorded figures; a transcript with no assistant records contributes zero, which is the truth |
| the skills directory | installed skills by category | a directory listing, not an assumption |
| the agents directory | installed agents | the same |
| the configuration file | the non-secret fields, for display | credential-shaped keys are dropped as defence in depth, though the file holds no secret by contract |

Token counts include cache reads and cache creation where the runtime recorded
them, labelled as such. Skill-invocation counts are explicit `Skill`-tool calls
only; a skill used implicitly is not counted, and the page says so rather than
guessing at it.

## Privacy

- The server binds to loopback and never to a public interface.
- It reads the transcripts and configuration and keeps no separate store of its
  own, so there is nothing of its own to leak or to clear. The Privacy tab states
  this and, when asked to clear analytics, explains that it holds none and points
  at the transcript files the user can delete themselves.
- The configuration reader never emits a credential.

## Files

```
control-center/
  server.py    stdlib HTTP server, loopback only, free-port detection
  reader.py    reads transcripts, installed skills and agents, configuration
  app.html     the single self-contained page, inline CSS and hand-authored SVG
  README.md    usage, options, privacy
```

## Requirements

Python 3.8 or later, present on most systems. No other dependency, and no network
access.
