# Example: a hotfix that did not become a second incident

14:52. Reports that some users cannot complete checkout. Released version is
`v2.4.0`, deployed three hours earlier.

## Triage

```
14:52  reports arrive, three users
14:54  error reporter shows termsAccepted null, 41 occurrences since 12:20
14:58  cause: v2.4.0 added a required terms checkbox; the mobile web layout
       hides it below the fold and the validation message renders off screen.
       Users see a submit button that does nothing.
15:01  affected: mobile web checkout, roughly 30 percent of attempts
```

Severity justifies the hotfix path: money, reachable, ongoing.

## The branch decision

```
Wrong:  branch from main, which contains 9 commits merged since the release
Right:  branch from the v2.4.0 tag
```

Branching from `main` would have shipped nine untested-in-production changes
into a production incident, which is how a hotfix becomes the second incident.

```bash
git checkout -b hotfix/checkout-terms-visibility v2.4.0
```

## The smallest change

```
Considered and rejected: redesigning the checkout layout. Correct, and far
too large for a hotfix.

Done: the terms checkbox moves above the submit button, and the validation
message renders adjacent to the field. Two files, eleven lines.
```

A hotfix fixes the incident. Everything else it might improve goes to the
register.

## The pipeline was not shortened

```
static        48s   pass
unit          1m14  pass
integration   2m38  pass
security      31s   pass
e2e           4m11  pass, including the new mobile viewport case
```

Nine minutes and twenty two seconds. Under pressure the temptation is to skip
the end to end stage, which is exactly the stage that covers the defect's
class.

What was shortened: the review. One reviewer instead of two, and the change is
eleven lines they read in a minute.

## The test that went with it

```ts
test("terms checkbox is reachable and validated at 375px", async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 667 })
  await goToCheckout(page)
  await expect(page.getByRole("checkbox", { name: /terms/i })).toBeInViewport()
  await page.getByRole("button", { name: "Pay" }).click()
  await expect(page.getByRole("alert")).toContainText("accept the terms")
})
```

`toBeInViewport` is the assertion that encodes the actual defect. A test that
only checked the checkbox exists would have passed against the broken version.

## Release and verification

```
15:24  tagged v2.4.1, annotated
15:26  deployed, rolling, health gated
15:31  full traffic

Production verification
  version      v2.4.1 reported                              pass
  journey      mobile checkout completed at 375px           pass
  journey      desktop checkout unaffected                  pass
  data         a test order persisted, then removed         pass
  errors       no termsAccepted null since 15:31            pass

Watch 30 minutes: checkout completion rate returned to the pre release
baseline within 8 minutes.
```

## The step that is always forgotten

```bash
git checkout main
git merge hotfix/checkout-terms-visibility
```

15:48. Without it, the next ordinary release from `main` reintroduces the
defect, and it arrives with no obvious cause because everyone remembers fixing
it.

The merge back is part of the hotfix, not a follow up task.

## The record

```
Version:      v2.4.1
Commit:       4d19f0e, branched from v2.4.0
Released:     2026-08-11 15:24
Kind:         hotfix
Incident:     mobile web checkout blocked by an off screen terms checkbox
Affected:     roughly 30 percent of checkout attempts, 12:20 to 15:31, 3h11
Impact:       41 abandoned checkouts observed
Contents:     checkbox moved above the submit button, validation message
              rendered adjacent
Pipeline:     full, 9m22
Review:       one reviewer, 11 lines
Merged back:  main, 15:48
Verification: verified, 5 of 5 checks
Follow up:    FU24 the checkout layout at narrow widths needs a proper pass;
              this fix is minimal by design
```

## What made it work

Branching from the tag, running the full pipeline, writing the test that
encodes the defect, and merging back the same afternoon.

The only thing shortened was the review, which is the step whose shortening
carries the least risk on an eleven line change.
