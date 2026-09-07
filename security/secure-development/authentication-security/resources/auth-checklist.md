# Authentication audit checklist

Run every line. Each is a yes/no with a file reference. A no is a finding,
ranked on the security-core scale.

## Password storage
- [ ] Memory-hard hash (argon2id / scrypt / bcrypt), not a general hash
- [ ] Per-password unique salt
- [ ] Parameters tuned to a meaningful cost, reviewed over time
- [ ] Constant-time comparison, from the library, not hand-rolled
- [ ] No password ever logged or stored in plaintext, anywhere

## Login flow
- [ ] Rate limited per account and per source
- [ ] Same response text for unknown account and wrong password
- [ ] Same response timing for unknown account and wrong password
- [ ] No status-code difference that reveals account existence
- [ ] Generic error, never "wrong password" vs "no such user"

## Credential recovery
- [ ] Reset token is single-use, time-limited, high-entropy, stored hashed
- [ ] Token invalidated on use and on a new request
- [ ] Flow response is identical for existing and non-existing accounts
- [ ] All existing sessions and tokens invalidated after a reset
- [ ] Request endpoint rate limited

## Multi-factor
- [ ] Offered for any account whose compromise is expensive
- [ ] TOTP or hardware key available, not SMS-only
- [ ] Backup codes generated once, stored hashed, shown once
- [ ] Re-authentication required to enable or disable a factor
- [ ] Second factor verified server side on every login

## Tokens and sessions
- [ ] Short access lifetime, longer refresh, both revocable server side
- [ ] Web tokens in HttpOnly cookies, not readable by script where possible
- [ ] Logout, password change and reset all revoke server side
- [ ] Token carries identity only, never a secret or a client-trusted role

## The distinction
- [ ] This flow establishes identity only; it grants no capability
- [ ] Every capability decision is made in authorization-design, server side
