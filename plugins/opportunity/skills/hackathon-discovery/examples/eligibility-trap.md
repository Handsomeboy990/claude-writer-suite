# Example: the eligibility rule that the event name hides

A participant looks for online hackathons they can join solo as a working
professional in the EU. Four events come back from live sources; reading the
actual rules changes the picture.

## The four events, then their real rules

```
1  "Global AI Hackathon"          sounds open to all
   real rules (read from source): prizes restricted to US residents; EU
   participants may compete but cannot win. For a participant whose goal is a
   portfolio piece, fine; for one whose goal is winning, this is a mismatch.
   -> reported with the restriction stated, fit depends on the goal

2  "Student Innovation Jam"        sounds student-only
   real rules: defines "student" as anyone enrolled in any course, including
   online ones, in the last two years. The working professional took an online
   course last year, so is eligible. The name would have excluded them; the rules
   include them. -> eligible, reported with the definition

3  "Weekend Build Challenge"       sounds solo-friendly
   real rules: teams of 2 to 4 required; no solo entries. The participant wants to
   enter solo. -> ineligible for a solo entry; reported as such, not recommended
   unless they form a team

4  "Open Source Sprint"            sounds online
   real rules: hybrid, with a mandatory in-person final in another country. The
   participant wants fully online. -> fails the availability/location constraint
```

## What verification against the source changed

```
event 1  a "global" event that a region cannot win; the name hid the prize rule
event 2  a "student" event the professional is actually eligible for; the name hid
         the broad definition
event 3  a "solo-friendly"-sounding event that forbids solo entries
event 4  an "online"-sounding event with a mandatory in-person component
```

Every one of these would have been mis-assessed from the name and reputation. The
rules, read from the source, are the truth.

## Shortlist

```
enter    event 2: eligible, online, solo, fits the skills; the strong match once
         the definition is read
consider event 1 only if the goal shifts to a portfolio piece, since the EU prize
         restriction rules out winning
drop     event 3 (solo forbidden) and event 4 (in-person final) against the stated
         constraints, unless the participant relaxes them
deadlines event 2: registration closes <exact date from source>, submission
         <exact date>; both stated, neither approximated
```

## The lesson

Not one of these events could be assessed from its name. The eligibility trap in
hackathon discovery is trusting the summary; the discipline is reading the actual
rules from the source and reporting exactly what they say, including the two
deadlines, because a participant is about to commit a weekend on it.
