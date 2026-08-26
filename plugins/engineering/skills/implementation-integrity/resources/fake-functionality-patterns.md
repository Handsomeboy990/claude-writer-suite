# Fake functionality patterns

Each pattern with what it looks like in code, why it survives review, and what
replaces it.

## 1. The mock save

```ts
async function saveProfile(data: Profile) {
  await new Promise((r) => setTimeout(r, 800))
  toast.success("Profile saved")
}
```

Survives review because it has an await, a delay that feels like a network
call, and a success message. Passes any test that checks for the toast.

Replaced by the real call, with the error path, and verified by the reload
test.

## 2. The ignored result

```ts
const result = await api.invitations.create(input)
toast.success("Invitation sent")
router.push("/team")
```

`result` is never read. A 409 conflict, a 403 or a 500 all produce the same
success message and the same redirect. The user is told an invitation was sent
that does not exist.

This is the most common form and the hardest to spot, because every line is
real code doing real work.

## 3. The floating promise

```ts
export async function POST(req: Request) {
  const input = await parse(req)
  createInvitation(input)          // no await
  return Response.json({ ok: true })
}
```

The handler returns before the work completes. On a fast local machine it
usually finishes anyway, which is why it passes development testing and fails
under load or when the database is slow.

## 4. The swallowed failure

```ts
try {
  await sendInvitationEmail(invitation)
} catch {}
return { success: true }
```

The catch is empty and the caller reports success. Nobody learns that mail has
been failing for three weeks.

Replaced by: log at the right level, record the delivery state, and tell the
user the truth, which may still be a success for the invitation and a pending
state for its delivery.

## 5. The hardcoded list

```tsx
const recentOrders = [
  { id: "1", total: 49.9, customer: "Jean Dupont" },
  { id: "2", total: 120.0, customer: "Marie Martin" },
]
```

Written to build the UI before the API exists, which is legitimate, and then
never replaced, which is not. It demonstrates beautifully.

Detection: sample names, round numbers, sequential identifiers, and a shape
that mirrors a table.

## 6. The dead control

```tsx
<Button onClick={() => {}}>Export</Button>
<a href="#">Download report</a>
<Button disabled>Coming soon</Button>
```

The third is acceptable and the first two are not. The difference is whether
the interface tells the truth about what it can do.

## 7. The permission placeholder

```ts
function canEditCourse(user: User, course: Course) {
  return true // TODO: implement
}
```

Written to unblock the UI, and it is a security hole with a comment on it.
This one belongs to `security-audit` as much as to this skill.

## 8. The optimistic update with no rollback

```tsx
setItems([...items, newItem])
api.items.create(newItem)
```

The list shows the item. The request fails. The item stays on screen until a
reload, so the user believes it was created.

Replaced by: rollback on failure, or no optimism.

## 9. The fake authentication

```ts
if (password.length > 0) {
  session.set("userId", user.id)
}
```

Appears during early development to avoid setting up hashing, and occasionally
survives to a staging environment that is reachable from the internet.

## 10. The unread form field

```tsx
<input name="phone" />
...
const body = { email, role }   // phone never read
```

The user fills in a field that goes nowhere. Common after a form is extended
and the submit handler is not.

Detection: compare the fields rendered with the fields sent.

## 11. The provider call that is never made

```ts
async function charge(order: Order) {
  logger.info("charging", { orderId: order.id })
  return { status: "succeeded", id: `ch_${order.id}` }
}
```

Written to test the checkout flow without a provider account, and it returns a
plausible object with a plausible identifier. Downstream code cannot tell.

Required form when the provider genuinely is unavailable:

```ts
async function charge(): Promise<ChargeResult> {
  throw new ProviderNotConfigured("Stripe credentials are not configured")
}
```

Loud, named, and impossible to mistake for a success.

## 12. The test that protects the fake

```ts
it("saves the profile", async () => {
  const spy = vi.spyOn(api, "updateProfile").mockResolvedValue({ ok: true })
  await saveProfile(data)
  expect(spy).toHaveBeenCalled()
})
```

Green, and it verifies that a mocked function was called. If `saveProfile`
ignores the result, or the endpoint behind it does nothing, this test stays
green.

The test that would catch it asserts the effect: after the call, read the
profile back and check the field changed.

## Grep starting points

Adapt to the project language. These find the honest stubs; the dynamic pass
finds the rest.

```
TODO|FIXME|XXX|HACK|WIP|not implemented|coming soon
placeholder|dummy|fake|mock            (excluding test directories)
setTimeout.*resolve                    (simulated work)
onClick=\{\(\) => \{\}\}               (dead control)
href="#"                               (dead link)
catch\s*\{\s*\}                        (swallowed failure)
catch.*\{\s*(console|logger)\.\w+\(.*\)\s*\}   (logged and continued)
return true;?\s*//\s*TODO              (permission placeholder)
```
