# opportunity

Discovering and evaluating opportunities, whatever their shape. Nine skills across
three categories that share one method: discover a field of possibilities,
evaluate them against reality, and recommend a few with reasoning, never dump a
hundred.

The tree's constitution is [ideation/opportunity-core](ideation/opportunity-core/).
Every skill refers to it and none restates it. Two rules never bend: an
opportunity (an idea's premise, a hackathon, a lead, a market figure) is grounded
in something verifiable or marked a hypothesis, never fabricated; and the
deliverable is always the evaluated few with their reasoning and next steps, not
the long list they came from.

| Category | Skills | Question it answers |
|---|---|---|
| [ideation](ideation/) | 3 | which ideas are worth pursuing, and how to test them |
| [hackathons](hackathons/) | 3 | which hackathon to enter and how to win it |
| [business](business/) | 3 | who to sell to, how to reach them, and whether the market is real |

## ideation

| Skill | Runs | Produces |
|---|---|---|
| [opportunity-core](ideation/opportunity-core/) | first, always | the discover-evaluate-recommend method and grounding rule |
| [ideation-engine](ideation/ideation-engine/) | to generate | a diverse, grounded idea set worth evaluating |
| [idea-evaluation](ideation/idea-evaluation/) | to choose | a ranked few, each with its riskiest assumption and cheap test |

## hackathons

| Skill | Runs | Produces |
|---|---|---|
| [hackathon-discovery](hackathons/hackathon-discovery/) | to find events | real hackathons matched, eligibility and deadlines verified |
| [hackathon-strategy](hackathons/hackathon-strategy/) | once chosen | a scoped project, a build plan, a team allocation to win |
| [pitch-and-demo](hackathons/pitch-and-demo/) | to present | a problem-first pitch and a working demo, rehearsed |

## business

| Skill | Runs | Produces |
|---|---|---|
| [client-discovery](business/client-discovery/) | to find prospects | qualified, signalled prospects with real contacts |
| [lead-research](business/lead-research/) | to approach one | a sourced dossier and a grounded, honest outreach draft |
| [market-research](business/market-research/) | to size a field | bottom-up sizing, a competitor map, an honest assessment |

## The shared method

```
discover (ideation-engine, hackathon-discovery, client-discovery, market-research)
  -> evaluate (idea-evaluation, hackathon fit, prospect qualification, sizing)
  -> recommend a ranked few, with reasoning and next steps
```

A long list is the easy, useless half. The value is in the evaluation and the
honest recommendation, including the honest "nothing here is worth it" when that
is the finding.

## Live sources

The discovery and business skills read whatever job, event, business and search
sources the runtime exposes. They read and prepare; they never register, apply,
or send outreach on the actor's behalf without explicit per-action confirmation.
When a source cannot be reached, they hand over the exact search to run rather
than inventing events, prospects, or figures.

Full picture: [../README.md](../README.md).
