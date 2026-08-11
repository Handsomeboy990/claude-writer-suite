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

Install `gh`, then authenticate. The default web flow grants the `repo`
scope, which is what this endpoint needs.

```bash
gh auth login
gh auth status
```

The endpoint takes a JSON body with nested objects and a `restrictions` field
that must be present and may be null. Passing that with repeated `-F` flags
does not work reliably; send a file.

```bash
cat > /tmp/protection.json <<'JSON'
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["structure, rules, orchestration"]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_conversation_resolution": true
}
JSON

for branch in main dev; do
  gh api -X PUT \
    "repos/Handsomeboy990/claude-writer-suite/branches/$branch/protection" \
    -H "Accept: application/vnd.github+json" \
    --input /tmp/protection.json
done

rm /tmp/protection.json
```

The required check is named after the job's `name:` in
`.github/workflows/validate.yml`. It must have run at least once before
GitHub will accept it as a context. If it has not, apply everything else
first, let one pull request run the workflow, then add the check.

Verify, per branch:

```bash
gh api repos/Handsomeboy990/claude-writer-suite/branches/main/protection --jq '
  "approvals            : \(.required_pull_request_reviews.required_approving_review_count)",
  "code owner review    : \(.required_pull_request_reviews.require_code_owner_reviews)",
  "required check       : \(.required_status_checks.contexts | join(", "))",
  "force pushes allowed : \(.allow_force_pushes.enabled)",
  "applies to admins    : \(.enforce_admins.enabled)"'
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
API, decides whether the rule also applies to repository administrators.

Its real behaviour, verified by attempting a direct push to both protected
branches:

| Value | A contributor pushes directly | An administrator pushes directly |
|---|---|---|
| off | rejected | **allowed**, logged as `Bypassed rule violations` |
| on | rejected | rejected |

This is worth reading twice. With `enforce_admins` off, protection does not
stop you. It stops everyone else. The server prints the rules that were
violated and accepts the push anyway:

```
remote: Bypassed rule violations for refs/heads/main:
remote: - Changes must be made through a pull request.
remote: - Required status check "structure, rules, orchestration" is expected.
```

That is the intended configuration here: contributors go through a pull
request, the owner keeps a way to publish a release or fix an emergency.

Turning it on with a single maintainer locks you out of your own repository:
GitHub does not allow approving your own pull request, so with bypass disabled
there is no path to a merge. Leave it off until `.github/CODEOWNERS` names a
second reviewer, then turn it on:

```bash
gh api -X POST \
  repos/Handsomeboy990/claude-writer-suite/branches/main/protection/enforce_admins
```

If you want the branch closed even to yourself before then, the honest option
is not `enforce_admins` but `lock_branch`, which makes the branch read only
for everyone and has to be lifted deliberately.

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

## Current state

Both branches are protected, verified by reading the rule back and by
attempting a direct push to each.

| Setting | main | dev |
|---|---|---|
| Pull request required | yes | yes |
| Approvals required | 1 | 1 |
| Code owner review required | yes | yes |
| Stale approvals dismissed | yes | yes |
| Required check | `structure, rules, orchestration` | same |
| Branch must be up to date | yes | yes |
| Conversations resolved | yes | yes |
| Linear history | yes | yes |
| Force pushes | refused | refused |
| Deletions | refused | refused |
| Applies to administrators | no | no |

## What is still not enforced

- **The owner is not blocked.** `enforce_admins` is off, so an administrator
  push to `main` or `dev` succeeds with a logged bypass. Contributors are
  blocked. See the table above for why it is set this way.
- The hook only exists in clones where `core.hooksPath` was set. A fresh clone
  has no hook until the command is run.
- A repository administrator can always disable protection entirely. That is
  by design; the audit trail is in the repository's security log.
- Nothing prevents a maintainer from merging their own pull request while
  `enforce_admins` is off. That is the trade-off accepted above, recorded here
  rather than left implicit.
