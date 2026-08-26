# Example: a search run, filtered, and reported honestly

The candidate from career-profile: a senior backend engineer targeting staff
roles, remote-first, authorised to work in the EU, excluding their current
employer. The search is built from that and run against the reachable sources.

## Search parameters

```
titles      staff engineer, staff backend engineer, principal engineer (backend)
hard        remote (EU timezone) OR EU-based hybrid; EU work authorisation;
            full-time; exclude <current employer>
soft        prefer infrastructure/platform teams; company size 50-500
terms       "staff", "backend", "platform", "distributed systems", "Go"
sources     job connector + company career pages reachable via retrieval
```

## Raw results, then hard-filtered

```
8 openings returned from live sources
  - 2 dropped: on-site only, wrong city (fail the remote/EU constraint)
  - 1 dropped: the excluded current employer
  - 1 dropped: contract, candidate wants full-time
  4 survive
```

## The four, reported honestly

```
1  Staff Backend Engineer, <Company A>   [strong match]
   requires: Go, distributed systems at scale, cross-team leadership
   match: met on Go and scale; PARTLY on cross-team leadership (the profile's gap)
   why: closest to the candidate's real strengths; the RFC evidence addresses the
        leadership requirement well
   link: <real URL at source>    deadline: none stated

2  Principal Engineer, <Company B>        [stretch, labelled]
   requires: 10+ years, formal org-wide technical authority
   match: candidate has 7 years; this asks for more seniority than the profile
   why: a considered stretch; worth it only if the candidate wants reach, and the
        cover letter would need to lead hard on the org-wide RFC
   link: <real URL>              deadline: <stated date>

3  Staff Platform Engineer, <Company C>   [strong match]
   requires: Kubernetes, platform work, mentoring
   match: met across the board; the candidate's migration and mentoring evidence
          fit precisely
   link: <real URL>              deadline: <stated date>

4  Senior+ Backend, <Company D>           [good match, slightly below target]
   requires: senior backend, some leadership
   match: met; this is at or just below the candidate's level, a safe application
   link: <real URL>              deadline: none stated
```

## Shortlist and effort

```
apply first   1 and 3: strong matches at the target level; tailor the CV to lead
              with the migration (1) and the platform work (3)
consider      2 as a labelled stretch, only if reaching up; not a strong fit
safe          4 as a floor option
effort        four real, tailored applications beat a scattered fifty; spend the
              time on 1 and 3
handoff       cv-engineering and cover-letter to tailor per role; company-research
              on Companies A and C before applying
```

## What the search did not do

It did not pad the list with plausible-sounding openings to look thorough. Eight
real results, four after honest filtering, reported with real links and the
deadlines the sources actually stated. Two roles carried "none stated" rather
than an invented date.
