# Threat-generation prompts, per boundary crossing

At each trust boundary in the data flow, ask every question below. A yes is a
candidate threat. Write it as: an attacker who is <X> can do <Y> because <Z>.

## Spoofing (pretend to be someone else)

- Can a request claim an identity it has not proven?
- Is the caller of this service authenticated, or trusted by position?
- Can a token, a cookie or a header be forged or replayed?

## Tampering (change data)

- Can the client change a value the server then trusts (price, role, id)?
- Is data modifiable in transit? At rest by someone who should only read?
- Can a request replay or reorder to a different effect?

## Repudiation (deny an action)

- If this action is disputed, is there a record that contradicts the denial?
- Is the record itself tamper-evident, or can the actor edit it?

## Information disclosure (read what you should not)

- Does this response include a field the caller is not entitled to?
- Does an error message leak structure, a path, a stack, a query?
- Can an identifier in the request address another user's row?

## Denial of service (make it unavailable)

- Is there an input whose cost to process is disproportionate to its size?
- Is there a limit on this operation, per user and in total?
- Can one caller exhaust a shared resource: connections, memory, a queue?

## Elevation of privilege (gain a capability)

- Can a value from the request set a role, a plan, an ownership field?
- Is authorization checked at every route, or only at the front door?
- Can a lower-privileged path reach a higher-privileged operation?

## Using the prompts

Walk the six at every crossing, not once for the whole system. The same
question has a different answer at the client boundary and at the third-party
integration boundary, and the second is the one usually forgotten.
