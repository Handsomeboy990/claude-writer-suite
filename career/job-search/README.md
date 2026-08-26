# job-search

Finds real openings that match the candidate's profile from live sources, never
invented: builds the search from the profile and configuration, queries the job
boards and connectors the runtime can reach, filters by hard constraints and
honest match, and reports each opening with its company, requirements, honest
match, real application link and stated deadline.

- Inputs: the career profile, the configuration, the reachable live sources.
- Outputs: search parameters, matched openings, match analysis, application shortlist.
- Depends on: career-core, career-profile.
- Downstream: cv-engineering, cover-letter, company-research, interview-preparation.

Every opening is real, from a live source, with a real link and a real deadline.
A fabricated listing sends a real person to apply for a job that does not exist.
If no live source can be reached, the skill says so and hands over the exact
search to run, rather than inventing results.
