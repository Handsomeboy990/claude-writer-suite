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

# An assistant message whose output exceeds this many tokens is counted as a
# large output. It is a signal to surface, never a judgement: a large output can
# be exactly what the task required. The threshold is documented so the count is
# reproducible.
LARGE_OUTPUT_TOKENS = 4000


def _short_path(path):
    """Shorten an absolute path to its last two segments for display.

    The full path can be sensitive and is long; the tail is enough to identify
    the file in a finding. No path is followed or opened here.
    """
    if not path:
        return ""
    parts = [p for p in str(path).split("/") if p]
    return "/".join(parts[-2:]) if len(parts) > 2 else str(path)


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


def _bash_signature(command):
    """A coarse signature of a shell command, so near-identical commands group.

    The first two whitespace-separated tokens (typically the program and its
    subcommand) identify the shape of the command without capturing its
    arguments, which is what makes two runs count as a repetition of the same
    kind of work rather than two unrelated commands.
    """
    parts = command.strip().split()
    if not parts:
        return "(empty)"
    sig = parts[0]
    if len(parts) > 1 and not parts[1].startswith("-"):
        sig += " " + parts[1]
    return sig[:40]


def _median(values):
    if not values:
        return 0
    s = sorted(values)
    n = len(s)
    mid = n // 2
    if n % 2:
        return s[mid]
    return (s[mid - 1] + s[mid]) // 2


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
                                       "fresh_in": 0, "tokens_out": 0, "messages": 0})
    per_day = defaultdict(lambda: {"tokens_in": 0, "fresh_in": 0, "tokens_out": 0,
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
                        "cache_read": 0,
                        "cache_creation": 0,
                        "messages": 0,
                        "tools": Counter(),
                        "models": Counter(),
                        # Evidence for the optimization advisor, all from real
                        # tool-call inputs. No inference is stored here, only
                        # counts of what actually happened.
                        "files_read": Counter(),
                        "files_edited": Counter(),
                        "bash_signatures": Counter(),
                        "bash_count": 0,
                        "output_tokens_per_msg": [],
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
                        sessions[sid]["cache_read"] += cr
                        sessions[sid]["cache_creation"] += cc
                        sessions[sid]["messages"] += 1
                        if to > 0:
                            sessions[sid]["output_tokens_per_msg"].append(to)
                    per_project[project]["tokens_in"] += ti + cr + cc
                    per_project[project]["fresh_in"] += ti
                    per_project[project]["tokens_out"] += to
                    per_project[project]["messages"] += 1
                    if sid:
                        per_project[project]["sessions"].add(sid)
                    if day:
                        per_day[day]["tokens_in"] += ti + cr + cc
                        per_day[day]["fresh_in"] += ti
                        per_day[day]["tokens_out"] += to
                        per_day[day]["messages"] += 1
                        if sid:
                            per_day[day]["sessions"].add(sid)
                    for blk in msg.get("content") or []:
                        if isinstance(blk, dict) and blk.get("type") == "tool_use":
                            tname = blk.get("name") or "?"
                            inp = blk.get("input") or {}
                            tools[tname] += 1
                            if sid:
                                s = sessions[sid]
                                s["tools"][tname] += 1
                                # Real file access and command evidence, used by
                                # the advisor to detect repeated exploration,
                                # edit churn and command repetition.
                                if tname in ("Read", "NotebookEdit") and inp.get("file_path"):
                                    s["files_read"][str(inp["file_path"])] += 1
                                elif tname in ("Edit", "Write") and inp.get("file_path"):
                                    s["files_edited"][str(inp["file_path"])] += 1
                                elif tname == "Bash" and inp.get("command"):
                                    s["bash_count"] += 1
                                    s["bash_signatures"][_bash_signature(str(inp["command"]))] += 1
                            if tname == "Skill":
                                sname = inp.get("skill")
                                if sname:
                                    skills[str(sname)] += 1

    # Shape sessions for output, newest first by last activity. The evidence
    # block carries only real counts; the advisor turns them into findings.
    session_list = []
    for s in sessions.values():
        dur = None
        if s["first"] and s["last"]:
            dur = int((s["last"] - s["first"]).total_seconds())
        total_tok = s["tokens_in"] + s["tokens_out"]
        fresh_in = s["tokens_in"] - s["cache_read"] - s["cache_creation"]
        if fresh_in < 0:
            fresh_in = 0
        # "Work" tokens: fresh input plus generated output. Cache reads, which
        # are the same context re-read cheaply each turn and would otherwise
        # dominate every figure, are excluded so session sizes are comparable.
        work_tok = fresh_in + s["tokens_out"]
        reads = s["files_read"]
        edits = s["files_edited"]
        bash_sigs = s["bash_signatures"]
        out_msgs = s["output_tokens_per_msg"]
        session_list.append({
            "id": s["id"],
            "project": s["project"],
            "branch": s["branch"],
            "start": s["first"].isoformat() if s["first"] else None,
            "end": s["last"].isoformat() if s["last"] else None,
            "duration_seconds": dur,
            "tokens_in": s["tokens_in"],
            "fresh_in": fresh_in,
            "tokens_out": s["tokens_out"],
            "tokens_total": total_tok,
            "work_tokens": work_tok,
            "cache_read": s["cache_read"],
            "cache_creation": s["cache_creation"],
            "messages": s["messages"],
            "tool_calls": sum(s["tools"].values()),
            "tool_types": len(s["tools"]),
            "top_tools": s["tools"].most_common(5),
            "models": s["models"].most_common(3),
            "evidence": {
                "reads_total": sum(reads.values()),
                "reads_unique": len(reads),
                "repeated_reads": [
                    {"file": _short_path(f), "count": c}
                    for f, c in reads.most_common(5) if c >= 3
                ],
                "edits_total": sum(edits.values()),
                "edits_unique": len(edits),
                "churned_files": [
                    {"file": _short_path(f), "count": c}
                    for f, c in edits.most_common(5) if c >= 4
                ],
                "bash_total": s["bash_count"],
                "repeated_bash": [
                    {"signature": sig, "count": c}
                    for sig, c in bash_sigs.most_common(5) if c >= 5
                ],
                "output_max": max(out_msgs) if out_msgs else 0,
                "output_median": _median(out_msgs),
                "large_outputs": sum(1 for v in out_msgs if v >= LARGE_OUTPUT_TOKENS),
            },
        })
    session_list.sort(key=lambda x: x["end"] or "", reverse=True)

    projects_out = []
    for name, p in per_project.items():
        projects_out.append({
            "name": name,
            "sessions": len(p["sessions"]),
            "tokens_in": p["tokens_in"],
            "fresh_in": p["fresh_in"],
            "tokens_out": p["tokens_out"],
            "messages": p["messages"],
        })
    projects_out.sort(key=lambda x: x["fresh_in"] + x["tokens_out"], reverse=True)

    days_out = []
    for day, d in sorted(per_day.items()):
        days_out.append({
            "date": day,
            "tokens_in": d["tokens_in"],
            "fresh_in": d["fresh_in"],
            "tokens_out": d["tokens_out"],
            "messages": d["messages"],
            "sessions": len(d["sessions"]),
        })

    # Overview statistics over per-session work tokens (fresh input plus output,
    # excluding cheap cache re-reads), so the figures are comparable and not
    # dominated by re-read context.
    session_totals = [s["work_tokens"] for s in session_list]
    largest = sorted(session_list, key=lambda x: x["work_tokens"], reverse=True)[:5]
    smallest = sorted(
        (s for s in session_list if s["work_tokens"] > 0),
        key=lambda x: x["work_tokens"])[:5]
    total_cache_read = totals["cache_read_tokens"]
    total_cache_creation = totals["cache_creation_tokens"]
    cache_base = total_cache_read + total_cache_creation
    overview = {
        "sessions": len(sessions),
        "tokens_total": sum(session_totals),
        "avg_tokens_per_session": (sum(session_totals) // len(session_totals)) if session_totals else 0,
        "median_tokens_per_session": _median(session_totals),
        "cache_reuse_ratio": round(total_cache_read / cache_base, 4) if cache_base else None,
        "largest_sessions": [
            {"id": s["id"], "project": s["project"], "work_tokens": s["work_tokens"]}
            for s in largest
        ],
        "smallest_sessions": [
            {"id": s["id"], "project": s["project"], "work_tokens": s["work_tokens"]}
            for s in smallest
        ],
    }

    return {
        "available": len(files) > 0,
        "transcript_files": len(files),
        "totals": totals,
        "session_count": len(sessions),
        "overview": overview,
        "sessions": session_list,
        "tools": tools.most_common(30),
        "skills": skills.most_common(60),
        "models": models.most_common(),
        "projects": projects_out,
        "days": days_out,
        "large_output_threshold": LARGE_OUTPUT_TOKENS,
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
        print("Projects by work tokens (fresh input plus output)")
        for p in u["projects"][:10]:
            tot = _fmt(p["fresh_in"] + p["tokens_out"])
            print(f"  {p['name']:<28} {p['sessions']} sessions  {tot} tokens")
        print(line)
        # Optimization summary. advisor is imported lazily so the reader stays
        # independent of it; if it is unavailable the report simply omits this.
        try:
            import advisor as _advisor
            adv = _advisor.analyze(data)
            if adv.get("available"):
                score = adv.get("score")
                print("Optimization score    "
                      + (f"{score} / 100" if score is not None else "not available"))
                print(f"  findings            {adv.get('findings_total', 0)}"
                      f" across {adv.get('sessions_analysed', 0)} sessions")
                for pat in adv.get("patterns", [])[:6]:
                    print(f"  {pat['category']:<26} {pat['count']}")
                print(line)
        except Exception:  # noqa: BLE001  the report is useful without it
            pass
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
