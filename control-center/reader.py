#!/usr/bin/env python3
"""Read local Claude session data and the installed suite state.

The Control Center never fabricates a metric. This module reads only what the
local files actually contain: session transcripts under the projects directory,
and the skills, agents and configuration that the installer wrote. When a value
cannot be established from those files, it is reported as unavailable, never
guessed.

No third-party dependency. Standard library only.

Sources, and their honesty:
- Sessions, tokens, models, tools and skills come from the assistant records in
  the transcripts. Token counts are the real usage figures the runtime recorded.
- Per-project and per-day breakdowns come from the record's own cwd and
  timestamp.
- Installed skills and agents come from listing the target directories.
- Configuration is read from the config file, which by contract holds no secret;
  this module never reads or emits a credential.
"""

import json
import os
import sys
import glob
import datetime
from collections import Counter, defaultdict

HOME = os.path.expanduser("~")
PROJECTS_DIR = os.environ.get(
    "CLAUDE_PROJECTS_DIR", os.path.join(HOME, ".claude", "projects")
)
SKILLS_DIR = os.environ.get(
    "CLAUDE_SKILLS_DIR", os.path.join(HOME, ".claude", "skills")
)
AGENTS_DIR = os.environ.get(
    "CLAUDE_AGENTS_DIR", os.path.join(HOME, ".claude", "agents")
)
CONFIG_FILE = os.environ.get(
    "CLAUDE_CONFIG_FILE", os.path.join(HOME, ".claude", "writer-suite.config.yaml")
)


def _project_name(raw):
    """A readable project name from the transcript directory or a cwd path."""
    if not raw:
        return "unknown"
    base = os.path.basename(raw.rstrip("/"))
    # Transcript directories encode the path with dashes; keep the last segment.
    if base.startswith("-") or "-home-" in base:
        parts = [p for p in base.split("-") if p]
        return parts[-1] if parts else base
    return base


def _parse_ts(ts):
    if not ts:
        return None
    try:
        return datetime.datetime.fromisoformat(ts.replace("Z", "+00:00"))
    except (ValueError, AttributeError):
        return None


def read_transcripts():
    """Aggregate the real figures from every transcript. Returns a dict.

    Everything here is derived from records that exist. A transcript with no
    assistant records contributes a session with zero tokens, which is the
    truth, not an omission.
    """
    pattern = os.path.join(PROJECTS_DIR, "*", "*.jsonl")
    files = sorted(glob.glob(pattern))

    sessions = {}          # sessionId -> aggregate
    tools = Counter()
    skills = Counter()
    models = Counter()
    per_project = defaultdict(lambda: {"sessions": set(), "tokens_in": 0,
                                       "tokens_out": 0, "messages": 0})
    per_day = defaultdict(lambda: {"tokens_in": 0, "tokens_out": 0,
                                   "messages": 0, "sessions": set()})

    totals = {
        "input_tokens": 0,
        "output_tokens": 0,
        "cache_read_tokens": 0,
        "cache_creation_tokens": 0,
        "assistant_messages": 0,
        "user_messages": 0,
    }

    for path in files:
        project_dir = os.path.basename(os.path.dirname(path))
        try:
            fh = open(path, "r", errors="replace")
        except OSError:
            continue
        with fh:
            for line in fh:
                line = line.strip()
                if not line:
                    continue
                try:
                    rec = json.loads(line)
                except json.JSONDecodeError:
                    continue
                rtype = rec.get("type")
                sid = rec.get("sessionId")
                ts = _parse_ts(rec.get("timestamp"))
                day = ts.date().isoformat() if ts else None
                project = _project_name(rec.get("cwd") or project_dir)

                if sid and sid not in sessions:
                    sessions[sid] = {
                        "id": sid,
                        "project": project,
                        "branch": rec.get("gitBranch") or "",
                        "first": ts,
                        "last": ts,
                        "tokens_in": 0,
                        "tokens_out": 0,
                        "messages": 0,
                        "tools": Counter(),
                        "models": Counter(),
                    }
                if sid and ts:
                    s = sessions[sid]
                    if s["first"] is None or ts < s["first"]:
                        s["first"] = ts
                    if s["last"] is None or ts > s["last"]:
                        s["last"] = ts

                if rtype == "user":
                    totals["user_messages"] += 1
                    if day:
                        per_day[day]["messages"] += 0  # user turns not counted as cost
                elif rtype == "assistant":
                    totals["assistant_messages"] += 1
                    msg = rec.get("message") or {}
                    model = msg.get("model")
                    if model and model != "<synthetic>":
                        models[model] += 1
                        if sid:
                            sessions[sid]["models"][model] += 1
                    usage = msg.get("usage") or {}
                    ti = int(usage.get("input_tokens") or 0)
                    to = int(usage.get("output_tokens") or 0)
                    cr = int(usage.get("cache_read_input_tokens") or 0)
                    cc = int(usage.get("cache_creation_input_tokens") or 0)
                    totals["input_tokens"] += ti
                    totals["output_tokens"] += to
                    totals["cache_read_tokens"] += cr
                    totals["cache_creation_tokens"] += cc
                    if sid:
                        sessions[sid]["tokens_in"] += ti + cr + cc
                        sessions[sid]["tokens_out"] += to
                        sessions[sid]["messages"] += 1
                    per_project[project]["tokens_in"] += ti + cr + cc
                    per_project[project]["tokens_out"] += to
                    per_project[project]["messages"] += 1
                    if sid:
                        per_project[project]["sessions"].add(sid)
                    if day:
                        per_day[day]["tokens_in"] += ti + cr + cc
                        per_day[day]["tokens_out"] += to
                        per_day[day]["messages"] += 1
                        if sid:
                            per_day[day]["sessions"].add(sid)
                    for blk in msg.get("content") or []:
                        if isinstance(blk, dict) and blk.get("type") == "tool_use":
                            tname = blk.get("name") or "?"
                            tools[tname] += 1
                            if sid:
                                sessions[sid]["tools"][tname] += 1
                            if tname == "Skill":
                                sname = (blk.get("input") or {}).get("skill")
                                if sname:
                                    skills[str(sname)] += 1

    # Shape sessions for output, newest first by last activity.
    session_list = []
    for s in sessions.values():
        dur = None
        if s["first"] and s["last"]:
            dur = int((s["last"] - s["first"]).total_seconds())
        session_list.append({
            "id": s["id"],
            "project": s["project"],
            "branch": s["branch"],
            "start": s["first"].isoformat() if s["first"] else None,
            "end": s["last"].isoformat() if s["last"] else None,
            "duration_seconds": dur,
            "tokens_in": s["tokens_in"],
            "tokens_out": s["tokens_out"],
            "messages": s["messages"],
            "top_tools": s["tools"].most_common(5),
            "models": s["models"].most_common(3),
        })
    session_list.sort(key=lambda x: x["end"] or "", reverse=True)

    projects_out = []
    for name, p in per_project.items():
        projects_out.append({
            "name": name,
            "sessions": len(p["sessions"]),
            "tokens_in": p["tokens_in"],
            "tokens_out": p["tokens_out"],
            "messages": p["messages"],
        })
    projects_out.sort(key=lambda x: x["tokens_in"] + x["tokens_out"], reverse=True)

    days_out = []
    for day, d in sorted(per_day.items()):
        days_out.append({
            "date": day,
            "tokens_in": d["tokens_in"],
            "tokens_out": d["tokens_out"],
            "messages": d["messages"],
            "sessions": len(d["sessions"]),
        })

    return {
        "available": len(files) > 0,
        "transcript_files": len(files),
        "totals": totals,
        "session_count": len(sessions),
        "sessions": session_list,
        "tools": tools.most_common(30),
        "skills": skills.most_common(60),
        "models": models.most_common(),
        "projects": projects_out,
        "days": days_out,
    }


def read_installed():
    """What the suite has installed, from the target directories."""
    skills = []
    if os.path.isdir(SKILLS_DIR):
        for name in sorted(os.listdir(SKILLS_DIR)):
            d = os.path.join(SKILLS_DIR, name)
            skill_md = os.path.join(d, "SKILL.md")
            if os.path.isfile(skill_md):
                category = ""
                desc = ""
                try:
                    with open(skill_md, "r", errors="replace") as fh:
                        for ln in fh:
                            if ln.startswith("description:"):
                                desc = ln.split(":", 1)[1].strip()[:140]
                            elif ln.strip().startswith("category:"):
                                category = ln.split(":", 1)[1].strip()
                            if desc and category:
                                break
                except OSError:
                    pass
                skills.append({"name": name, "category": category, "description": desc})
    agents = []
    if os.path.isdir(AGENTS_DIR):
        for name in sorted(os.listdir(AGENTS_DIR)):
            if name.endswith(".md") and name != "README.md":
                agents.append(name[:-3])
    return {
        "skills_dir": SKILLS_DIR,
        "agents_dir": AGENTS_DIR,
        "skills": skills,
        "skill_count": len(skills),
        "agents": agents,
        "agent_count": len(agents),
    }


def read_config():
    """Read the configuration for display. Never emits a secret.

    The configuration contract forbids secrets in this file, so reading it is
    safe. As defence in depth, any line whose key looks credential-shaped is
    dropped rather than displayed.
    """
    if not os.path.isfile(CONFIG_FILE):
        return {"present": False, "path": CONFIG_FILE, "fields": {}}
    secretish = ("token", "secret", "password", "key", "credential", "api")
    fields = {}
    section = None
    try:
        with open(CONFIG_FILE, "r", errors="replace") as fh:
            for ln in fh:
                raw = ln.rstrip("\n")
                if not raw.strip() or raw.strip().startswith("#"):
                    continue
                if not raw.startswith(" ") and raw.endswith(":"):
                    section = raw[:-1].strip()
                    fields[section] = {}
                    continue
                if ":" in raw:
                    k, v = raw.split(":", 1)
                    k = k.strip()
                    v = v.split("#", 1)[0].strip().strip('"')
                    if any(s in k.lower() for s in secretish):
                        continue
                    if section is not None:
                        fields[section][k] = v
    except OSError:
        return {"present": True, "path": CONFIG_FILE, "fields": {}}
    return {"present": True, "path": CONFIG_FILE, "fields": fields}


def collect():
    """The full data object the server serves and the report prints."""
    return {
        "generated_at": datetime.datetime.now().isoformat(timespec="seconds"),
        "usage": read_transcripts(),
        "installed": read_installed(),
        "config": read_config(),
        "notes": {
            "token_source": "real usage figures recorded in local transcripts",
            "privacy": "all data is local; nothing is sent anywhere",
        },
    }


def _fmt(n):
    n = int(n)
    if n >= 1_000_000:
        return f"{n/1_000_000:.1f}M"
    if n >= 1_000:
        return f"{n/1_000:.1f}K"
    return str(n)


def print_report():
    data = collect()
    u = data["usage"]
    inst = data["installed"]
    cfg = data["config"]
    line = "-" * 60
    print("Claude Skill Suite, usage report")
    print(f"Generated {data['generated_at']}")
    print(line)
    if not u["available"]:
        print("No local session data found under:")
        print(f"  {PROJECTS_DIR}")
        print("Nothing to report. This is not an error; the suite works without it.")
    else:
        t = u["totals"]
        print(f"Transcript files      {u['transcript_files']}")
        print(f"Sessions              {u['session_count']}")
        print(f"Assistant messages    {t['assistant_messages']}")
        print(f"Input tokens          {_fmt(t['input_tokens'])}")
        print(f"  cache read          {_fmt(t['cache_read_tokens'])}")
        print(f"  cache creation      {_fmt(t['cache_creation_tokens'])}")
        print(f"Output tokens         {_fmt(t['output_tokens'])}")
        print(line)
        print("Models")
        for m, c in u["models"]:
            print(f"  {m:<28} {c}")
        print(line)
        print("Top tools")
        for name, c in u["tools"][:12]:
            print(f"  {name:<28} {c}")
        print(line)
        if u["skills"]:
            print("Skill invocations")
            for name, c in u["skills"][:20]:
                print(f"  {name:<28} {c}")
            print(line)
        print("Projects by token use")
        for p in u["projects"][:10]:
            tot = _fmt(p["tokens_in"] + p["tokens_out"])
            print(f"  {p['name']:<28} {p['sessions']} sessions  {tot} tokens")
        print(line)
    print(f"Installed skills      {inst['skill_count']}  in {inst['skills_dir']}")
    print(f"Installed agents      {inst['agent_count']}  in {inst['agents_dir']}")
    if cfg["present"]:
        ident = cfg["fields"].get("identity", {})
        author = ident.get("author_name", "")
        print(f"Configured author     {author or '(unset)'}")
    else:
        print("Configuration         not written yet (run install.sh --configure)")
    print(line)
    print("All figures are read from local files. Nothing is sent anywhere.")


def main(argv):
    if "--json" in argv:
        json.dump(collect(), sys.stdout, indent=2, default=str)
        sys.stdout.write("\n")
        return 0
    # Default and --report both print the text report.
    print_report()
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
