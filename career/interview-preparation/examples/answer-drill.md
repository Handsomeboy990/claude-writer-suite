# Example: turning a CV claim into a follow-up-proof answer

The CV says "reduced production incidents by a third". The interview will test
whether that claim survives a conversation. Preparation turns it into an answer
that holds under pressure.

## The claim, and the questions it invites

```
claim         "reduced incidents by a third over two quarters"
interviewer   "tell me about that"  ->  "how did you measure it"  ->  "what was
              the hardest part"  ->  "what would you do differently"
```

A candidate who cannot answer the follow-ups did not really do the work, as far
as the interviewer can tell. Preparation makes the real work articulable.

## The structured answer

```
situation   "Our team was shipping weekly, and roughly a fifth of deploys caused
            a production incident, mostly from changes that passed tests but
            failed under real load."
action      "I introduced two things: health-gated releases that automatically
            rolled back if error rates crossed a threshold in the first ten
            minutes, and a load-shaped staging environment so the failures showed
            up before production."
result      "Over two quarters, incidents per deploy dropped by about a third,
            measured off our incident tracker, and we moved from weekly to daily
            deploys because releases were safer."
learned     "The rollback automation mattered more than the staging environment,
            which surprised me; I would build the automated rollback first next
            time."
```

## Drilling the follow-ups

```
"how did you measure it"      -> the incident tracker, incidents-per-deploy over
                                 two quarters; a real, citable method
"what was the hardest part"   -> getting the rollback threshold right: too tight
                                 and it rolled back healthy deploys; a real,
                                 specific difficulty
"what would you do differently" -> build the automation before the staging env;
                                 the honest reflection, already in the answer
```

Each follow-up has a real answer because the candidate really did the work. The
drill surfaces those answers so they come fluently, not because they are invented.

## Where the mock caught a weak spot

In the first mock, the candidate said "we reduced incidents significantly", which
is vaguer than the CV's "a third" and invites "how significant, exactly?". The
feedback: use the real number, and be ready to cite how it was measured. Re-drilled,
the answer led with the concrete figure and its source.

## The lesson

The claim was true, so the follow-ups all had honest answers; preparation made
them fluent. Had the claim been inflated, the drill would have exposed exactly
where it breaks, which is the argument for career-core's honesty rule at the CV
stage: the interview finds what the CV overstated.
