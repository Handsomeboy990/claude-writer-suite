# career

Helping a real person find and win real roles. Seven skills that build an honest
profile, find real openings, render a CV and cover letter that survive both a
parser and an interview, research the employer, and rehearse the conversation.

The tree's constitution is [career-core](career-core/). Every skill refers to it
and none restates it. Two rules never bend: nothing about the outside world (a
listing, a company, a deadline, a salary) is invented and everything is traced to
a live source; and nothing about the candidate is claimed that they cannot
support in a conversation. The strongest application is a true one, presented well.

| Skill | Runs | Produces |
|---|---|---|
| [career-core](career-core/) | first, always | honesty standard, source rule, configuration read |
| [career-profile](career-profile/) | first in any career work | the honest profile every other skill reads |
| [job-search](job-search/) | to find roles | real openings, honest match, real links and deadlines |
| [company-research](company-research/) | before applying or interviewing | sourced company profile, health, culture, red flags |
| [cv-engineering](cv-engineering/) | to write the CV | a parseable, quantified, tailored CV, every line true |
| [cover-letter](cover-letter/) | per role | a specific, honest letter that earns the interview |
| [interview-preparation](interview-preparation/) | before the interview | answers from real experience, drilled with follow-ups |

## The flow

```
career-core (read config, set honesty rule)
  -> career-profile (the source of truth)
  -> job-search (real openings) + company-research (the employer)
  -> cv-engineering + cover-letter (the application, tailored, true)
  -> interview-preparation (rehearse honestly)
```

## Configuration

The career skills read the `career` section of the configuration before acting:
target roles, skills, experience, location, remote preference, industries,
employers, employment type, and constraints such as work authorisation and an
optional salary floor. Missing fields are asked for once, grouped, never invented.
Field reference: [../config/README.md](../config/README.md).

## Live sources and connectors

`job-search` and `company-research` read whatever job, freelance, and search
sources the runtime exposes. They read and prepare; they never apply, post, or
message on the candidate's behalf without explicit per-action confirmation. When
a source cannot be reached, they say so and hand the candidate the exact search to
run, rather than inventing results.

Full picture: [../README.md](../README.md).
