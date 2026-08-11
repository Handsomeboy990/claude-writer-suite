# Branch protection

The rules that decide who may write to `main` and `dev`, and how a change gets
in.

## The model

```
main    release branch. Receives only pull requests from dev, opened by a
        maintainer. Never written to directly.

dev     integration branch. Every contribution targets it. Receives only pull
        requests from feature branches.

<type>/<short-description>
        where work happens. Branched from dev, merged back into dev.
```

Contributor flow, in full:

```bash
git switch dev
git pull
git switch -c feat/my-change
# work, commit
git push -u origin feat/my-change
# open a pull request into dev
```

A contributor never targets `main`. A maintainer promotes `dev` into `main`
when a set of changes is ready to release.

## What enforces it

Three layers, in increasing order of strength.

| Layer | Where | Stops | Can be bypassed |
|---|---|---|---|
| `.githooks/pre-push` | each clone | the honest mistake, before the network | yes, with `--no-verify` or a fresh clone |
| `.github/CODEOWNERS` | the repository | a merge without the owner's approval | only by an administrator |
| Branch protection | GitHub settings | everything else, including force pushes | only by an administrator |

The hook is a convenience. **Branch protection is the rule.** Configure it,
or the other two are decoration.

## Enabling the hook

Once per clone:

```bash
git config core.hooksPath .githooks
```

It refuses a direct push to `main` or `dev`, refuses their deletion, refuses a
commit attributed to a tool, and refuses a commit with an empty author.

A maintainer performing a deliberate release push can override it:

```bash
ALLOW_PROTECTED_PUSH=yes git push origin main
```

There is no override for the attribution and empty-author checks. Those are
defects, not preferences.

## Configuring branch protection

Required once, by a repository administrator. Two routes.

### With the GitHub CLI

Install `gh` first, then authenticate:

```bash
gh auth login
```

`dev`:

```bash
gh api -X PUT repos/Handsomeboy990/claude-writer-suite/branches/dev/protection \
  -H "Accept: application/vnd.github+json" \
  -F required_pull_request_reviews[required_approving_review_count]=1 \
  -F required_pull_request_reviews[require_code_owner_reviews]=true \
  -F required_pull_request_reviews[dismiss_stale_reviews]=true \
  -F required_status_checks[strict]=true \
  -F required_status_checks[contexts][]="structure, rules, orchestration" \
  -F enforce_admins=false \
  -F restrictions=null \
  -F allow_force_pushes=false \
  -F allow_deletions=false \
  -F required_linear_history=true \
  -F required_conversation_resolution=true
```

`main`, same rule with `enforce_admins` left off so a maintainer can still
perform a release merge, and force pushes refused:

```bash
gh api -X PUT repos/Handsomeboy990/claude-writer-suite/branches/main/protection \
  -H "Accept: application/vnd.github+json" \
  -F required_pull_request_reviews[required_approving_review_count]=1 \
  -F required_pull_request_reviews[require_code_owner_reviews]=true \
  -F required_pull_request_reviews[dismiss_stale_reviews]=true \
  -F required_status_checks[strict]=true \
  -F required_status_checks[contexts][]="structure, rules, orchestration" \
  -F enforce_admins=false \
  -F restrictions=null \
  -F allow_force_pushes=false \
  -F allow_deletions=false \
  -F required_linear_history=true \
  -F required_conversation_resolution=true
```

Verify:

```bash
gh api repos/Handsomeboy990/claude-writer-suite/branches/main/protection
gh api repos/Handsomeboy990/claude-writer-suite/branches/dev/protection
```

### Through the web interface

`Settings` then `Branches` then `Add branch ruleset`, or the classic
`Add branch protection rule`.

For each of `main` and `dev`:

| Setting | Value |
|---|---|
| Require a pull request before merging | on |
| Required approvals | 1 |
| Dismiss stale approvals when new commits are pushed | on |
| Require review from Code Owners | on |
| Require status checks to pass | on |
| Required check | `structure, rules, orchestration` |
| Require branches to be up to date before merging | on |
| Require conversation resolution before merging | on |
| Require linear history | on |
| Allow force pushes | off |
| Allow deletions | off |
| Do not allow bypassing the above settings | see below |

### The one setting to think about

`Do not allow bypassing the above settings`, called `enforce_admins` in the
API, decides whether the rule also applies to you.

| Value | Consequence |
|---|---|
| off, recommended to start | you can still merge a release or fix an emergency without disabling protection |
| on | nobody bypasses, including you; you need a second maintainer for every merge, since GitHub does not let you approve your own pull request |

With a single maintainer, `on` locks you out of your own repository: you
cannot approve your own pull request, and with bypass disabled you cannot
merge without an approval. Leave it off until there is a second reviewer, then
turn it on.

## Making the reviewer requirement real

`Require review from Code Owners` is what turns `.github/CODEOWNERS` into a
rule. Without it, CODEOWNERS only requests a review; it does not require one.

CODEOWNERS is read from the **base branch** of the pull request. A change to
that file takes effect only once it is merged into the branch it protects. So
after the first release merge, verify that `main` carries it:

```bash
git show main:.github/CODEOWNERS
```

## Adding an authorized reviewer

1. Give them write access to the repository.
2. Add their handle to `.github/CODEOWNERS`, on the `*` line.
3. Open that change as a pull request into `dev`, then release it to `main`.
   Both branches need the updated file.

Removing a reviewer is the same operation in reverse. Nothing about
authorisation lives outside that file and the repository's collaborator list.

## What is still not enforced

- The hook only exists in clones where `core.hooksPath` was set. A fresh
  clone has no hook until the command is run.
- A repository administrator can always disable protection. That is by design;
  the audit trail is in the repository's security log.
- Nothing prevents a maintainer from merging their own pull request while
  `enforce_admins` is off. That is the trade-off accepted above, and it is
  recorded here rather than left implicit.
