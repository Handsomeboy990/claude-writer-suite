# security-core

Constitution of the security tree. The defensive posture, the authorization
boundary that decides whether any offensive action is permitted, the severity
scale every finding is ranked on, the evidence rule that forbids the word
secure, and the fix-and-verify discipline that separates a finding from a
closed defect.

- Inputs: the system or change under security work, and the posture required.
- Outputs: security posture, authorization decision, severity ranking, finding record.
- Depends on: nothing. Copy the directory and use it alone.
- Downstream: every skill in the security tree refers to it and none restates it.

Two rules never bend: no offensive action without written, specific, in-scope
authorization on record, and no audit ever concludes that a system is secure.
It reports which checks were run, with which results, on which revision.
