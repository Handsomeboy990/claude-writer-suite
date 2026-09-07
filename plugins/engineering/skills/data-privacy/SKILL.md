---
name: data-privacy
description: Builds privacy into the system rather than onto it: an inventory of the personal data actually held, a lawful and stated purpose for each field, minimisation and retention with deletion that works, access control and audit, subject rights implemented as features, third party sharing, consent where it applies, and the rules that keep personal data out of logs, evidence and analytics. Use before collecting a new field, and whenever personal data crosses a boundary.
license: MIT
metadata:
  category: dev-skills
  version: 1.0.0
  depends_on: [engineering-core, database-design]
  outputs: [data-inventory, retention-rules, deletion-plan, subject-request-procedures, sharing-register]
---

# Data Privacy

Privacy is an engineering property: what is collected, where it lives, who can
read it, how long it stays, and whether deletion actually deletes. A policy
document with none of that behind it is a promise the system cannot keep.

This skill covers engineering obligations. Legal interpretation belongs to a
lawyer, and nothing here substitutes for one.

## 1. Inventory

Nothing can be protected until it is known.

```
per field: what it is, why it is held, where it is stored, who can read it,
  how long it stays, where it is copied
copies are the problem: backups, analytics, logs, exports, caches, search
  indexes, mail providers, support tools, data warehouses, local development
sensitive categories identified explicitly: health, biometrics, beliefs,
  political opinions, sexual orientation, criminal records, precise location,
  children's data
indirect identifiers included: device identifiers, addresses, timestamps that
  identify a person in combination
```

Personal data is anything that identifies a person alone or in combination.
An identifier plus a timestamp is usually enough.

## 2. Minimisation

```
collect a field only when a named feature needs it, today
never collect because it might be useful later
prefer a derived value: an age band rather than a birth date, a region rather
  than coordinates
prefer a reference to a third party's record over a copy
delete a field when the feature that needed it is removed
question every free text field, because users put anything in them
```

The cheapest way to protect data is to not hold it.

## 3. Purpose and lawfulness

```
each field has a stated purpose, in the inventory
using data for a new purpose is a decision, not an implementation detail
consent, where it is the basis, is specific, recorded with its timestamp and
  its wording version, and as easy to withdraw as to give
a refused or withdrawn consent is honoured everywhere, including in systems
  that already received the data
legitimate interest, where used, has a written assessment
```

## 4. Access control and audit

```
personal data behind object level authorization, verified by security testing
staff access is role based, minimal, and logged
support tools show what is needed, not the whole record
production data is never copied to a development machine
non production environments use synthetic or anonymised data, and anonymised
  means irreversibly so
an access log exists for sensitive categories, and is itself protected
```

## 5. Retention and deletion

```
every category has a retention period, with a reason
a job enforces it, and its output is monitored
deletion means: rows, files, cache entries, search index entries, queue
  messages, analytics events, third party copies, and backups by their own
  expiry
what cannot be deleted immediately, such as an immutable backup, is stated
  with the date it expires
soft delete is not deletion, and the difference is documented honestly
anonymisation, where used, is tested against re-identification, since removing
  a name is not anonymisation
```

Deletion that leaves the row in a backup for a year is a legitimate design,
provided it is what the notice says.

## 6. Subject rights as features

Implemented as product capabilities, not as a manual database procedure:

```
access      a machine readable export of everything held about a person,
            assembled from every store, not only the main table
rectification an interface to correct data, propagating to copies
erasure     a documented procedure that reaches every store, with the
            exceptions named: legal retention, fraud prevention, accounting
portability a structured export in a common format
objection   a way to stop a specific processing without deleting the account
restriction a state where data is held but not processed
```

Each one is tested with a real request on a real account, and timed, because
the obligations have deadlines.

## 7. Sharing and third parties

```
a register of every processor: who, what data, why, where, under what contract
a new integration is a privacy decision before it is a technical one
data leaving a region is a decision that needs a legal basis
analytics and error tracking receive personal data unless configured not to
support tools, session recording and heatmaps are high risk by default
a breach at a processor is your incident too, and the contract should say how
  you learn about it
```

## 8. Data that leaks sideways

The routine engineering failures:

```
logs containing request bodies, headers, or user objects
error reports capturing local variables that hold personal data
analytics events with an email address as an identifier
screenshots and test evidence taken from real accounts
seed data copied from production
support exports mailed as spreadsheets
a search index holding fields the interface never displays
an API response carrying more fields than the interface uses
```

Each of these is a routine defect with a simple fix, and each has produced
real incidents.

## 9. Prohibitions

- Never collect a field with no named purpose.
- Never copy production personal data into a non production environment.
- Never log a request body, a token or a user object wholesale.
- Never use a personal identifier as an analytics key.
- Never claim deletion the system does not perform.
- Never treat pseudonymisation as anonymisation.
- Never add a third party that receives personal data without registering it.
- Never put real personal data in test evidence or documentation.

## 10. Protocol

1. Build the inventory, including every copy.
2. Remove what has no named purpose.
3. Record the purpose and the basis for each remaining field.
4. Verify access control on every personal data path.
5. Set retention per category and implement the enforcing job.
6. Implement erasure across every store, and name the exceptions.
7. Implement export, rectification, objection and restriction as features.
8. Register every processor and every transfer.
9. Sweep logs, analytics, error reports, evidence and non production data.
10. Test: a real export, a real erasure, and a verification that the erased
    data is gone from every store named in the inventory.

## 11. Auto-critique

Score from 0 to 5: inventory completeness including copies, minimisation
applied, purposes recorded, access control verified, retention enforced by a
job, erasure reaching every store, subject rights implemented and timed,
processor register, absence of personal data in logs and evidence.

Threshold: no axis below 3, average at least 4. A product that cannot produce
a complete export or perform a complete erasure has not implemented privacy,
whatever its notice says.

## 12. Interfaces

- Upstream: `requirements-analysis` for the obligations that apply,
  `database-design` for where data lives, `architecture-design` for the
  boundaries it crosses.
- Lateral: `security-audit` and `security-testing` for access control,
  `observability` for the redaction policy, `file-handling` for uploaded
  content and its metadata, `dependency-selection` for third parties.
- Downstream: `database-operations` for retention and erasure jobs,
  `testing-quality` for the rights tests, `technical-documentation` for the
  inventory and procedures, `incident-response` for a personal data breach.
