# Pre-commit checklist

Run before every commit. Two minutes here prevents a rotated key and a
rewritten history later.

## Identity

- [ ] `git config user.name` returns `Handsomeboy990`.
- [ ] `git config user.email` returns `lauretchacha@gmail.com`.
- [ ] The message contains no automated attribution of any kind.

## Content of the staged diff

```bash
git status
git diff --staged
```

- [ ] The staged diff was read in full, not skimmed.
- [ ] Every hunk belongs to the change described by the message.
- [ ] No unrelated file is staged.
- [ ] No debug output, no commented out code, no scratch file.
- [ ] No large binary that belongs in storage rather than in history.
- [ ] No generated artefact the project does not track.

## Secrets

```bash
git diff --staged | grep -inE \
  'api[_-]?key|secret|password|token|private[_-]?key|BEGIN [A-Z ]*PRIVATE KEY|postgres://|mysql://|mongodb\+srv://'
```

- [ ] The search returns nothing, or every hit is a variable name rather than
      a value.
- [ ] No `.env` file is staged.
- [ ] No credential file is staged.
- [ ] Test fixtures contain no real credential and no real personal data.

## Ignore rules

- [ ] `.env` and `.env.*` are ignored.
- [ ] Key and certificate patterns are ignored.
- [ ] Dependency and build directories are ignored.
- [ ] Editor, OS and agent local directories are ignored.
- [ ] Any deliberate exception is recorded, not silent.

## Quality gates

- [ ] The project formatter ran, or the diff is already conformant.
- [ ] The linter passes on the changed files.
- [ ] Type checking passes, where the project has it.
- [ ] The tests that cover the change were run and observed.

## Message

- [ ] Type prefix from the project's set.
- [ ] Imperative mood, English, no trailing period.
- [ ] Summary under about seventy characters.
- [ ] No `and` joining two changes.
- [ ] A body only where the summary is insufficient.

## After committing

```bash
git log --format='%h %an <%ae> %s' -5
```

- [ ] Author and email correct on every new commit.
- [ ] Messages read as a coherent sequence.
- [ ] Nothing was committed that the next section would have to undo.

## If a secret was committed

1. Do not push.
2. Remove it from the working tree and amend or rebase it out of history.
3. Rotate the credential regardless. Removal from history is not sufficient,
   because the value existed and may have been read.
4. Record the rotation as a manual action in the security report.
