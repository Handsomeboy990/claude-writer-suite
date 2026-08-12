# data-privacy

Builds privacy into the system: an inventory of the personal data actually
held including every copy, a purpose per field, minimisation, retention with
deletion that reaches every store, access control and audit, subject rights
implemented as features, a processor register, and the rules that keep
personal data out of logs, analytics and test evidence.

- Inputs: the data model, the features that collect data, the third parties,
  the obligations that apply.
- Outputs: data inventory, retention rules, deletion plan, subject request
  procedures, sharing register.
- Depends on: engineering-core, database-design.
- Lateral: security-audit, security-testing, observability, file-handling.
- Downstream: database-operations, testing-quality, technical-documentation,
  incident-response.

Covers engineering obligations only; legal interpretation belongs to a lawyer.
The cheapest way to protect data is not to hold it, and deletion is verified
against every store named in the inventory.
