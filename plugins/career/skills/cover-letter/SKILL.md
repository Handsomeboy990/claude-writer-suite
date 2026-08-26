---
name: cover-letter
description: Writes a cover letter that earns the interview: opens with a real reason for this company and role rather than a template, connects the candidate's genuine experience to the role's actual needs with specifics, addresses a gap honestly when one exists, matches the register of the industry, and stays short. Every claim is supportable and every letter is specific to its target. Use to write or improve a cover letter or application message for a specific role.
license: MIT
metadata:
  category: career
  version: 1.0.0
  depends_on: [career-core, career-profile]
  outputs: [cover-letter, opening-hook, evidence-connections, gap-handling]
---

# Cover Letter

A cover letter that could be sent to any company is read by none. Its whole value
is specificity: this candidate, this company, this role, this reason. This skill
writes the letter that connects the candidate's real experience to the role's
real needs, and it refuses the template that says nothing.

## 1. The opening earns the read

```
specific     a real reason for this company and this role, in the first sentence:
             something about the company's work, product, or problem that the
             candidate genuinely connects to, and why
not          "I am writing to apply for the position of X", which every letter says
not          flattery the candidate does not mean and cannot substantiate
true         the reason is real; a candidate who has no genuine interest in the
             company writes a letter that reads as if they have none, and forcing
             enthusiasm is worse than a plain competent opening
```

## 2. Connect real experience to real needs

```
role needs   the two or three things this role actually needs, from the listing
             and from company-research, not a guess
evidence     for each, the candidate's specific, true experience that meets it,
             with the concrete detail a CV bullet compresses out
show         "when I led the billing migration, I faced exactly the reliability
             problem your job posting describes, and here is what I did" beats
             "I am a strong problem-solver"
few          two or three strong connections, not a restatement of the whole CV;
             the letter complements the CV, it does not repeat it
```

## 3. Handle a gap honestly

```
when         the candidate is a real but incomplete fit and the gap is visible
address      name it briefly and turn to the bridge: the transferable strength,
             the fast track record, the genuine plan to close it
never        pretend the gap is not there (the reader sees it) or apologise at
             length (which amplifies it)
confidence   a gap owned in one honest sentence reads as self-awareness; a gap
             hidden reads as either ignorance or dishonesty when found
```

## 4. Register and length

```
register     match the industry and the company: a startup and a law firm expect
             different tones, and the letter reads the room from company-research
short        three or four short paragraphs; a cover letter is a page at most and
             usually less; the reader is busy and specificity is brief
close        a plain, confident close: what the candidate offers and a simple next
             step, without the servile "I would be grateful for the opportunity"
```

## 5. One letter per role

```
specific     each letter is written for its target; the specifics are not
             swappable, which is the point
reuse        the candidate's true material is reused; the connections to this role
             are fresh each time
tell         a letter where the company name could be find-and-replaced to another
             company has failed, and is rewritten
```

## 6. Prohibitions

- Never open with a template line that any application could use.
- Never claim an experience, skill, or result the candidate cannot support.
- Never manufacture enthusiasm the candidate does not have; a plain competent
  letter beats forced flattery.
- Never repeat the CV; the letter adds the specifics the CV compressed out.
- Never hide a visible gap or apologise for it at length; own it in a sentence.
- Never send a letter whose company name is interchangeable.
- Never exceed a page; specificity is brief.

## 7. Protocol

1. Read the profile, the role, and any `company-research` for the real reason and
   register.
2. Write an opening with a specific, true reason for this company and role.
3. Connect two or three of the role's real needs to the candidate's specific,
   supportable experience.
4. If a visible gap exists, own it in one honest sentence and turn to the bridge.
5. Match the register to the industry and company; keep it to a page.
6. Close plainly, with what the candidate offers and a simple next step.
7. Confirm the letter is specific to this target and every claim is supportable.

## 8. Auto-critique

Score from 0 to 5: opening specific and true not template, real needs connected
to supportable experience with concrete detail, gap owned honestly where visible,
register matched, length within a page, close confident not servile, letter
specific to this target and not swappable.

Threshold: no axis below 3, average at least 4. A swappable template letter, or
any claim the candidate cannot support, caps the score until fixed, per
career-core.

## 9. Interfaces

- Upstream: `career-core` for honesty, `career-profile` for the material,
  `job-search` for the role, `company-research` for the real reason and register.
- Downstream: `interview-preparation` builds on the connections the letter makes;
  the letter and `cv-engineering` form the application package.
- Lateral: `administrative-writing` in `documents/` for a formal letter's
  conventions and salutation; `rewriting-engine` in `writing/` to tighten prose.

## 10. Note on freelance and message formats

For a freelance platform or a cold outreach, the same rules apply in a shorter
form: a specific opening, one or two real connections, a plain close, and no
template. The medium is shorter; the specificity and the honesty are not
negotiable. A generic proposal on a freelance platform competes with dozens of
identical ones and loses to the one that read the brief.
