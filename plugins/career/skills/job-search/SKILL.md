---
name: job-search
description: Finds real openings that match the candidate's profile from live sources, never invented: builds the search from the profile and configuration, queries the job boards and connectors the runtime can reach, filters by hard constraints and honest match, and reports each opening with its company, requirements, honest match analysis, real application link and stated deadline. Use to find roles to apply to, and to rank a set of openings by fit.
license: MIT
metadata:
  category: career
  version: 1.0.0
  depends_on: [career-core, career-profile]
  outputs: [search-parameters, matched-openings, match-analysis, application-shortlist]
---

# Job Search

The one rule that governs this skill above all others: every opening it reports
is real, from a live source, with a real link and a real deadline. A fabricated
listing sends a real person to apply for a job that does not exist, which is the
worst thing a career tool can do. This skill finds real roles and tells the
truth about fit.

## 1. Build the search from the profile

```
targets     the target roles and their real requirements, from career-profile
hard        the non-negotiable filters from the configuration: location or remote,
            work authorisation, employment type, excluded employers
soft        the preferences that rank rather than exclude: industry, company size,
            desired employers
terms       the titles and keywords real listings use for these roles, which vary
            by market and are not assumed
```

## 2. Query live sources only

```
sources     the job boards, company career pages, and connectors the runtime can
            actually reach (a job connector, web search and retrieval)
real        every result is an opening that exists at its source right now
link        the real application URL at the source, not a constructed or guessed one
deadline    the deadline the source states; if none is stated, say "none stated",
            do not invent one
unreachable if no live source can be reached, say so plainly and give the search
            the candidate can run themselves, with the exact terms and boards;
            never substitute invented listings for a search that could not run
```

This is career-core's source rule, made operational. An opening that cannot be
traced to a live source is not reported as an opening.

## 3. Filter by hard constraints, then rank by honest match

```
exclude     drop anything failing a hard constraint: wrong location for an
            on-site role, excluded employer, wrong authorisation, wrong type
match       for each survivor, an honest analysis against the profile: which
            requirements the candidate meets, which partly, which not
rank        by genuine fit, not by how appealing the listing sounds; a role the
            candidate is a strong match for outranks a glamorous one they are not
honest      a stretch role is labelled a stretch, with what would make it viable;
            it is not hidden and it is not oversold
```

## 4. Report each opening usefully

```
role        the title and the company, from the source
requirements   what the listing actually asks for
match       met / partly / gap against the candidate's profile, honestly
why         the specific reason this role fits (or is a considered stretch)
link        the real application link
deadline    the stated deadline, or "none stated"
```

## 5. The shortlist

```
prioritise  the strong matches the candidate should apply to first
stretch     a small number of considered stretches, labelled, if the candidate
            wants reach
effort      where the candidate's limited application effort is best spent, said
            plainly; ten strong applications beat fifty scattered ones
next        for each shortlisted role, what to tailor in the CV and cover letter,
            handed to those skills
```

## 6. Prohibitions

- Never invent an opening, a company, a link, or a deadline.
- Never report an opening that cannot be traced to a live source.
- Never construct or guess an application URL; use the real one or none.
- Never invent a deadline; report the stated one or "none stated".
- Never oversell a stretch role as a strong match.
- Never ignore a hard constraint (authorisation, excluded employer) to lengthen
  the list.
- Never apply on the candidate's behalf without explicit per-action confirmation.

## 7. Protocol

1. Build the search from the profile and configuration: targets, hard filters,
   soft preferences, real listing terms.
2. Query the live sources the runtime can reach; if none, say so and hand over the
   runnable search.
3. Confirm each result is a real, current opening with a real link and a stated
   or absent deadline.
4. Drop anything failing a hard constraint.
5. Analyse each survivor's match honestly: met, partly, gap.
6. Rank by genuine fit; label stretches.
7. Produce the shortlist with where to spend effort and what to tailor.

## 8. Auto-critique

Score from 0 to 5: search built from the real profile and constraints, every
opening from a live source with a real link, deadlines stated or marked absent
not invented, hard constraints enforced, match analysis honest, ranking by fit
not glamour, stretches labelled, effort guidance given.

Threshold: no axis below 3, average at least 4. A single invented opening, link,
or deadline is an automatic zero regardless of the average, per career-core.

## 9. Interfaces

- Upstream: `career-core` for the source and honesty rules, `career-profile` for
  the targets and the match baseline.
- Downstream: `cv-engineering` and `cover-letter` tailor to a shortlisted role,
  `company-research` deepens the diligence on a target, `interview-preparation`
  prepares for the ones that respond.
- Lateral: `source-verification` in `research/` when a listing's legitimacy is in
  doubt (a scam posting), `synthesis-reporting` for a structured market view.

## 10. Live sources and connectors

This skill uses whatever job and search sources the runtime exposes: a job board
connector, a freelance-platform connector, web search and page retrieval. It
reads and prepares; it does not apply or message on the candidate's behalf unless
the candidate confirms that specific action. When the needed connector is not
configured, it says which one would help and how to enable it, and meanwhile
hands the candidate the exact search to run, rather than inventing what the
connector would have returned.
