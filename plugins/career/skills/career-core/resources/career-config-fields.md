# Career configuration fields

The `career` section the tree reads before acting. Every field describes the
candidate's real situation. A missing field is asked for once, grouped with the
others, and never filled with a plausible default.

| Field | What it holds | Why it must be real, not assumed |
|---|---|---|
| target_roles | the roles being pursued | a wrong assumption sends the whole search off-target |
| skills | what the candidate can actually do, with level | an assumed skill produces applications that fail at interview |
| experience | real titles, dates, results | the CV is built from this; invention here is fraud |
| location | where they are; relocation willingness | a wrong location returns unreachable listings |
| remote | on-site / hybrid / remote, and how strongly | decides which listings even qualify |
| industries | sectors of interest; sectors to avoid | focuses the search and respects hard exclusions |
| employers | desired companies; excluded companies | a candidate may not want their current employer to see a search |
| employment_type | full-time / part-time / contract / freelance | changes the source and the whole match |
| constraints | visa status, availability, salary floor (optional) | work authorisation and salary floor are decision-critical and never guessed |

## Rules for reading the configuration

- Read it before acting. A career skill that runs against an empty configuration
  asks for the fields it needs, once and grouped, and stops until it has them.
- Never guess a salary expectation. If the candidate did not state a floor, do
  not invent one; ask, or proceed without it and say so.
- Never assume work authorisation. Visa status changes which roles are reachable;
  a wrong assumption wastes real applications.
- The excluded-employers list is a hard boundary, often for a real reason (a
  current employer). Respect it silently and completely.

## Privacy

This section is personal data. It is used for the task and not sent anywhere the
candidate did not direct. It is never committed to a repository. The suite's
configuration file already forbids secrets; a salary floor and a job history are
treated with the same care.
