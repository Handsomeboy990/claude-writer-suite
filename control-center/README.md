# Control Center

An optional local dashboard for the suite. It reads the session data, skills,
agents and configuration that already exist on your machine, and shows them:
usage, tokens, models, tools, skills, projects and system health.

It is optional. Every skill works without it. Nothing here is required to
install, configure or use a single skill.

## What it is, and is not

- Zero dependency. Python 3 standard library and one HTML file. No `pip install`,
  no `npm install`, no build step, no lockfile, no `node_modules`.
- Local first. The server binds to `127.0.0.1` only. Nothing it shows leaves the
  machine. It opens no outbound connection.
- Honest. Every figure is read from local files. Token counts are the real usage
  figures recorded in your transcripts. When a metric cannot be established, it
  is shown as unavailable, never invented.

## Running it

```bash
bash install.sh --control-center
```

It finds a free port in a dedicated range (7317 upward, chosen to avoid the
usual development ports), prints the URL, and opens your browser. Stop it with
Ctrl-C.

Options:

```bash
bash install.sh --control-center --no-browser     # do not open a browser
bash install.sh --control-center --port 7400      # ask for a specific port
```

If the requested port is taken, the next free one in the range is used and the
chosen port is printed. A port is never assumed free; the binding is attempted.

Run it directly without the installer, from inside the repository:

```bash
python3 control-center/server.py --no-browser
```

## The command-line report

For the same data without a browser:

```bash
bash install.sh --report            # a text summary
python3 control-center/reader.py --json   # the full data as JSON
```

## What it shows

| Section | Source | Notes |
|---|---|---|
| Dashboard | transcripts | sessions, tokens, models, tools, tokens per day |
| Sessions | transcripts | per session: project, duration, tokens, top tools |
| Usage | transcripts | tool calls and explicit skill invocations |
| Projects | transcripts | token use grouped by the project each session ran in |
| Analytics | transcripts | tokens and messages per day |
| Skills | skills directory | what is installed, by category |
| System health | all sources | what the Control Center can see on this machine |
| Privacy | n/a | what is read, and what the tool keeps (nothing of its own) |

Token counts include cache reads and cache creation where the runtime recorded
them, labelled as such. The skill-invocation counts are explicit `Skill`-tool
calls only; a skill used implicitly is not counted, and the page says so rather
than guessing.

## Privacy

- The server binds to loopback (`127.0.0.1`) and never to a public interface.
- It reads your transcripts and configuration and keeps no separate store of its
  own, so there is nothing of its own to leak or to clear.
- The configuration reader drops any credential-shaped field as defence in depth,
  though by contract the configuration file holds no secret.
- To remove session history, delete the transcript files under your projects
  directory yourself. The Control Center only reads them.

## Files

```
control-center/
  server.py    stdlib HTTP server, loopback only, free-port detection
  reader.py    reads transcripts, installed skills/agents, configuration
  app.html     the single self-contained page, inline CSS and SVG charts
  README.md    this file
```

## Requirements

Python 3.8 or later, already present on most systems. No other dependency. The
server needs no network access and makes no outbound request.
