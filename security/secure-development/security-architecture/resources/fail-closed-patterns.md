# Fail-closed patterns

The safe behaviour has to be the one that happens when nobody thought about the
case. Below, the open default most systems have, and the closed structure that
inverts it.

## Authorization

```
fails open   if (user.isBlocked) return deny;  // else falls through to allow
fails closed default deny; allow only on an explicit, matched grant
             an unhandled role, a missing permission, a new route: all deny
```

## A switch over a trusted value

```
fails open   switch(role){ case 'admin': ...; case 'user': ...; }  // default: proceed
fails closed switch(role){ ...; default: reject('unknown role'); }
             a new role added to the system is denied until it is handled
```

## An external dependency

```
fails open   catch(e){ /* auth service down, let them in */ }
fails closed catch(e){ deny('cannot verify, refusing'); }
             unavailability of the check means the protected action does not happen
```

## A required input

```
fails open   const tenantId = req.tenantId || DEFAULT_TENANT;
fails closed if (!req.tenantId) reject('no tenant context'); // never a default
```

## A feature flag or config gate

```
fails open   if (config.securityCheckEnabled) verify();  // absent config = no check
fails closed verify() always; the flag can only make it stricter, never skip it
```

## The rule

Read every branch and ask: what happens on the path nobody wrote? If that path
admits, reads, or proceeds, the control fails open. Invert it so the unwritten
path denies. Then the next engineer who forgets a case is protected by the
structure instead of exposed by it.
