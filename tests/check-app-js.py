#!/usr/bin/env python3
"""Syntax-check the Control Center page script.

The Control Center page carries a substantial inline script. A syntax error in
it leaves the page blank with only a console error, which the other validators
would not catch. This check extracts the script and verifies it.

If node is available it uses `node --check` for a real parse. Otherwise it falls
back to a bracket-balance check that, while not a full parser, catches the
unbalanced-parenthesis class of error that a large hand-edited file is prone to.

    python3 tests/check-app-js.py
"""

import os
import re
import shutil
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
APP = os.path.join(ROOT, "control-center", "app.html")


def extract_script(html):
    blocks = re.findall(r"<script>(.*?)</script>", html, re.S)
    if not blocks:
        return None
    return blocks[-1]


def bracket_balance(js):
    """Balance of (), [], {} outside strings, template literals and comments.

    A minimal scanner: enough to catch an unbalanced bracket, not a full JS
    grammar. Returns a list of error strings.
    """
    errors = []
    stack = []
    pairs = {")": "(", "]": "[", "}": "{"}
    i, n = 0, len(js)
    line = 1
    in_str = None       # ", ', or `
    in_line_comment = False
    in_block_comment = False
    while i < n:
        c = js[i]
        nxt = js[i + 1] if i + 1 < n else ""
        if c == "\n":
            line += 1
            in_line_comment = False
            i += 1
            continue
        if in_line_comment:
            i += 1
            continue
        if in_block_comment:
            if c == "*" and nxt == "/":
                in_block_comment = False
                i += 2
                continue
            i += 1
            continue
        if in_str:
            if c == "\\":
                i += 2
                continue
            if c == in_str:
                in_str = None
            i += 1
            continue
        # not in a string or comment
        if c == "/" and nxt == "/":
            in_line_comment = True
            i += 2
            continue
        if c == "/" and nxt == "*":
            in_block_comment = True
            i += 2
            continue
        if c in ('"', "'", "`"):
            in_str = c
            i += 1
            continue
        if c in "([{":
            stack.append((c, line))
        elif c in ")]}":
            if not stack:
                errors.append("unexpected '%s' at line %d" % (c, line))
            else:
                op, ol = stack.pop()
                if pairs[c] != op:
                    errors.append("mismatched '%s' at line %d (opened '%s' at line %d)" % (c, line, op, ol))
        i += 1
    for op, ol in stack:
        errors.append("unclosed '%s' opened at line %d" % (op, ol))
    return errors


def main():
    try:
        html = open(APP, encoding="utf-8").read()
    except OSError as exc:
        print("ERROR   cannot read app.html: %s" % exc)
        return 1
    js = extract_script(html)
    if not js:
        print("ERROR   no <script> block found in app.html")
        return 1

    node = shutil.which("node")
    if node:
        proc = subprocess.run([node, "--check", "-"], input=js,
                              capture_output=True, text=True)
        if proc.returncode != 0:
            print("ERROR   app.html script failed node --check:")
            print(proc.stderr.strip())
            return 1
        print("app.html script: valid (node --check)")
        return 0

    errors = bracket_balance(js)
    if errors:
        print("ERROR   app.html script has unbalanced brackets:")
        for e in errors[:10]:
            print("        " + e)
        return 1
    print("app.html script: brackets balanced (node not available for a full parse)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
