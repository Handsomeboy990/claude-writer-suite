---
name: interview-preparation
description: Prepares a candidate for a real interview: builds answers from their true experience using a structured form, drills the behavioural and technical questions the role will actually ask, rehearses the honest handling of the gap and the hard question, prepares the candidate's own questions for the interviewer, and runs a realistic mock rather than a reassurance session. Every answer is grounded in something the candidate actually did. Use before an interview, and to turn a CV claim into a spoken answer.
license: MIT
metadata:
  category: career
  version: 1.0.0
  depends_on: [career-core, career-profile]
  outputs: [answer-bank, question-drills, gap-responses, candidate-questions]
---

# Interview Preparation

An interview tests whether the CV's claims survive a conversation. Preparation
turns each true claim into an answer the candidate can give under pressure, drills
the questions the role will actually ask, and rehearses the hard ones honestly. It
is a rehearsal, not a reassurance session, and its value is the honest one.

## 1. Build the answer bank from real experience

```
stories      the candidate's real experiences that each demonstrate something a
             role values: a hard problem solved, a conflict handled, a failure
             learned from, a result delivered
structure    a clear form the candidate can recall under pressure: the situation,
             what they did, the result, and what they learned; the form keeps a
             nervous answer from wandering
true         every story is something the candidate actually did; a fabricated
             story collapses under a follow-up question, and interviewers ask
             follow-up questions
reuse        one strong story often answers several questions from different
             angles; map which stories cover which competencies
```

## 2. Drill the questions the role will ask

```
behavioural  the "tell me about a time" questions for the competencies this role
             values; matched to the answer bank
technical    the real technical ground the role covers, at the level it expects;
             drilled honestly, including the ones the candidate finds hard
role         the questions specific to this company and role, from company-research:
             their stack, their domain, their known challenges
why          "why this company, why this role, why leaving": prepared with the same
             true specifics the cover letter used, so the story is consistent
```

## 3. Rehearse the hard questions honestly

```
gap          "you do not have experience with X": the honest bridge, the same one
             the profile and cover letter use, said in the candidate's own voice
failure      "tell me about a failure": a real one, what was learned, no
             disguised-humblebrag ("I work too hard"), which interviewers see through
salary       what to say when asked, aligned to the candidate's stated floor from
             the configuration, never a number the candidate did not choose
weakness     a real, non-fatal weakness with a genuine mitigation, not a strength
             in disguise
```

## 4. The candidate's own questions

```
prepare      real questions for the interviewer that show the candidate engaged
             with the role and the company, from company-research
signal       good questions (about the team's real challenges, how success is
             measured) signal seriousness; generic ones ("what is the culture
             like") signal none
diligence    the candidate is also assessing the employer; the questions surface
             what the candidate needs to know to accept an offer
```

## 5. The mock, run realistically

```
realistic    ask the actual hard questions, including the ones the candidate hopes
             to avoid; a mock that only asks the easy ones prepares nothing
followups    press with the follow-up questions a real interviewer asks: "why did
             you choose that", "what would you do differently", "walk me through it"
feedback     honest feedback on where an answer wandered, overstated, or would not
             survive a follow-up; the point is to find the weak answers now
iterate      re-drill the answers that failed until they are true, tight, and
             follow-up-proof
```

## 6. Prohibitions

- Never prepare a fabricated story or example; it collapses under follow-up.
- Never coach the candidate to claim experience they do not have.
- Never give a salary answer that contradicts the candidate's stated floor, or
  invents one they did not choose.
- Never prepare a fake weakness ("I care too much") or a humblebrag failure.
- Never run a mock that avoids the hard questions.
- Never send the candidate in without their own real questions prepared.

## 7. Protocol

1. Read the profile, the role, and company-research.
2. Build the answer bank: real stories in a recallable structure, mapped to
   competencies.
3. Drill the behavioural, technical, role-specific, and "why" questions.
4. Rehearse the gap, failure, salary, and weakness questions honestly.
5. Prepare the candidate's own real questions for the interviewer.
6. Run a realistic mock with follow-ups; give honest feedback.
7. Re-drill the answers that would not survive a follow-up until they hold.

## 8. Auto-critique

Score from 0 to 5: answer bank built from real experience in a recallable
structure, questions drilled match what the role will ask, hard questions
rehearsed honestly, salary aligned to the stated floor, candidate's own questions
prepared, mock realistic with follow-ups, weak answers found and re-drilled.

Threshold: no axis below 3, average at least 4. Preparing a fabricated story, or
a salary answer the candidate did not choose, caps the score until corrected, per
career-core.

## 9. Interfaces

- Upstream: `career-core` for honesty, `career-profile` for the material and the
  gap, `job-search` for the role, `company-research` for the role-specific
  questions and the register.
- Downstream: the prepared answers feed a stronger `career-profile` and future
  applications; a post-interview reflection updates the profile.
- Lateral: `self-critique` for the hiring-manager role pass on the answers.

## 10. Note on the honest gap

The single most valuable preparation is the honest answer to the gap the role
exposes. A candidate who can say "I have not done X; here is the closest thing I
have done and how fast I would close the gap" is more convincing than one who
bluffs and is caught. Preparation makes that honest answer fluent, which is what
turns a real gap from a disqualifier into evidence of self-awareness.
