# Audience profiles

One filled profile per document, before writing. Ten minutes here removes a
rewrite.

## Template

```markdown
Document:        <name>
Output language: <language, and why>
Primary reader:  <role>
Secondary:       <role, or none>

Already knows:      <what can be assumed>
Must not assume:    <what cannot>
Must be able to do:  <after reading>
Reading context:    screen | print | mobile | terminal | under pressure
Time available:     <minutes>
Cost of misreading: <consequence>
Register:           <formal | neutral | direct>
```

## Worked profiles

### Developer integrating an API

```
Already knows:      HTTP, JSON, their own language, authentication in general
Must not assume:    your naming, your error model, your rate limits, your idea of a resource
Must be able to do:  make an authenticated call and handle every documented failure
Reading context:    screen, split with an editor, copying and pasting
Time available:     five minutes before they try something
Cost of misreading: a broken integration discovered in their production
Register:           direct, second person, imperative for actions
```

Opens with a request and a response, both real. Anything before that costs
credibility.

### Technical administrator installing a system

```
Already knows:      shell, packages, services, networking, their platform
Must not assume:    your stack, your assumptions about their environment, root access
Must be able to do:  install, configure, verify, and know it worked
Reading context:    terminal, often on a server, sometimes with no internet
Time available:     a maintenance window
Cost of misreading: a failed install on a live system
Register:           procedural, exact, no prose between steps
```

Every step has an observable result. Every step has a rollback or the
document says there is none.

### End user completing a task

```
Already knows:      the task in their own words, not yours
Must not assume:    any system vocabulary, any technical concept, any patience for context
Must be able to do:  finish the task and recognise success
Reading context:    inside the product, mid task, mildly frustrated
Time available:     under a minute
Cost of misreading: a support ticket, or abandonment
Register:           plain, second person, the reader's nouns
```

Titled by the task, not the feature. `Change your delivery address`, never
`Address management`.

### Executive deciding

```
Already knows:      the business, the budget, the constraints
Must not assume:    technical detail, or that page two will be read
Must be able to do:  decide, or say what would let them decide
Reading context:    between meetings, on a phone
Time available:     ninety seconds
Cost of misreading: a decision taken on a wrong premise
Register:           formal, conclusion first, numbers with their source
```

Conclusion in the first paragraph. Options with what each costs. One
recommendation, stated as one.

### Support agent resolving a ticket

```
Already knows:      the product, common failures, the customer's tone
Must not assume:    access to source, or time to read architecture
Must be able to do:  match a symptom to a cause and resolve or escalate
Reading context:    with a customer waiting
Time available:     under two minutes
Cost of misreading: a wrong answer given with confidence
Register:           symptom first, then cause, then action
```

Indexed by symptom in the customer's words, not by component.

### Operations engineer at 3am

```
Already knows:      the infrastructure, the tooling, nothing about this alert
Must not assume:    alertness, context, or the presence of the author
Must be able to do:  understand the alert, run the first command, know when to escalate
Reading context:    phone, dark, urgent
Time available:     thirty seconds to the first action
Cost of misreading: an outage extended
Register:           imperative, one action per line, thresholds as numbers
```

The first command is in the first screen. Explanation comes after the
mitigation, never before it.

### Recipient of an administrative document

```
Already knows:      the file, the reference, their own situation
Must not assume:    goodwill, familiarity with your organisation, or a second reading
Must be able to do:  identify the subject, the request and the deadline immediately
Reading context:    print or PDF, filed with others
Time available:     one reading
Cost of misreading: a rejected application, a missed deadline, a dispute
Register:           formal, impersonal, no ambiguity that a reader could resolve two ways
```

Reference, date and subject before the first sentence of the body. Deadlines
as dates, never as durations.

## Multi-audience documents

A document with two audiences serves one and irritates the other.

| Situation | Resolution |
|---|---|
| Developer and administrator | two documents; the overlap is smaller than it looks |
| Client and internal team | two documents; the internal one says things the client one must not |
| Executive and technical | one document, executive summary first, technical annex after, no interleaving |
| User and support | one document indexed by task, one indexed by symptom |

The only sound single-document compromise is a layered one: a first page that
stands alone for the less technical reader, and depth after it, never mixed
into it.
