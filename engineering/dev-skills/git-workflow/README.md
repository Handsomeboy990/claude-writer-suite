# git-workflow

Version control discipline: the fixed author identity, the ban on any
automated attribution trailer, atomic commits with a two part test, imperative
English messages, a mandatory staged diff read before every commit, ignore
rule verification, branch conventions taken from the repository, and pull
request contents.

- Inputs: the working tree, the repository conventions.
- Outputs: commits, branches, pull request, history report.
- Depends on: engineering-core.
- Downstream: release-readiness, project-continuity.

## Configuration

| Field | Required | Effect when missing |
|---|---|---|
| `identity.author_name` | yes | the skill stops and names the field |
| `identity.author_email` | yes | the skill stops and names the field |
| `git.commit_convention` | no | defaults to `conventional` |
| `git.branch_convention` | no | defaults to `type/short-kebab-description` |
| `git.default_branch` | no | defaults to `main` |

Set them with `bash install.sh --configure`. Field reference in
`config/README.md`. A repository that already has conventions of its own wins
over the last three: the skill reads `git log` before it reads the file.

No `Co-authored-by`, no generator mention, no assistant mention, anywhere in
the history or the pull request. That rule is not configurable.
