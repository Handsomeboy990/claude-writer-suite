# Example: one journey, written twice

Journey: an administrator invites a member, the member appears as pending, a
duplicate invitation is refused.

## The version that gets written first

```ts
test("invite a member", async ({ page }) => {
  await page.goto("/login")
  await page.fill("#email", "admin@example.com")
  await page.fill("#password", "password123")
  await page.click(".btn-primary")
  await page.waitForTimeout(2000)
  await page.goto("/team")
  await page.click(".invite-button")
  await page.fill(".modal input", "ada@example.com")
  await page.click(".modal .btn-primary")
  await page.waitForTimeout(1000)
  expect(await page.locator(".invitation-row").count()).toBe(1)
})
```

Six problems, each of which will cost an afternoon later.

1. Signing in through the UI in every test, which triples the suite duration
   and makes every test depend on the login page.
2. Class based selectors, broken by any styling change.
3. Two `waitForTimeout` calls, which are slow when unnecessary and
   insufficient on a loaded machine.
4. A password in the test file.
5. Counting rows, which passes even if the row shows the wrong address.
6. No error state, no empty state, no keyboard, no narrow width.

## The version that ships

```ts
import { test, expect } from "./fixtures"

test.describe("team invitations", () => {
  test.use({ storageState: "e2e/.auth/admin.json" })

  test("invites a member and refuses a duplicate", async ({ page, team }) => {
    const email = `ada+${team.id}@example.test`

    await page.goto(`/teams/${team.id}/members`)

    // Empty state, asserted on the way through
    await expect(
      page.getByText("No invitations yet"),
    ).toBeVisible()

    await page.getByRole("button", { name: "Invite member" }).click()

    const dialog = page.getByRole("dialog", { name: "Invite a member" })
    await expect(dialog).toBeVisible()

    // Focus moved into the dialog
    await expect(dialog.getByRole("textbox", { name: "Email address" }))
      .toBeFocused()

    await dialog.getByRole("textbox", { name: "Email address" }).fill(email)
    await dialog.getByRole("combobox", { name: "Role" }).selectOption("member")
    await dialog.getByRole("button", { name: "Send invitation" }).click()

    // Outcome the user perceives
    await expect(page.getByRole("status")).toHaveText("Invitation sent")
    await expect(page.getByRole("row", { name: new RegExp(email) }))
      .toBeVisible()

    // Focus returned to the trigger after the dialog closed
    await expect(page.getByRole("button", { name: "Invite member" }))
      .toBeFocused()

    // Error state, in the same journey rather than a separate slow test
    await page.getByRole("button", { name: "Invite member" }).click()
    await dialog.getByRole("textbox", { name: "Email address" }).fill(email)
    await dialog.getByRole("button", { name: "Send invitation" }).click()

    await expect(dialog.getByRole("alert"))
      .toHaveText("An invitation is already pending for this address.")
    await expect(dialog.getByRole("textbox", { name: "Email address" }))
      .toHaveValue(email)                    // input preserved on failure
  })

  test("is operable by keyboard alone", async ({ page, team }) => {
    await page.goto(`/teams/${team.id}/members`)
    await page.keyboard.press("Tab")
    await page.keyboard.press("Tab")
    await expect(page.getByRole("button", { name: "Invite member" }))
      .toBeFocused()
    await page.keyboard.press("Enter")
    await expect(page.getByRole("dialog")).toBeVisible()
    await page.keyboard.press("Escape")
    await expect(page.getByRole("dialog")).toBeHidden()
    await expect(page.getByRole("button", { name: "Invite member" }))
      .toBeFocused()
  })

  test("fits the narrowest supported width", async ({ page, team }) => {
    await page.setViewportSize({ width: 320, height: 720 })
    await page.goto(`/teams/${team.id}/members`)

    await expect(page.getByRole("button", { name: "Invite member" }))
      .toBeVisible()

    const overflow = await page.evaluate(
      () => document.documentElement.scrollWidth > window.innerWidth,
    )
    expect(overflow).toBe(false)
  })
})
```

## What the fixtures do

```ts
// e2e/fixtures.ts
export const test = base.extend<{ team: Team }>({
  team: async ({}, use) => {
    const team = await createTeamViaApi()   // unique per test, parallel safe
    await use(team)
    await deleteTeamViaApi(team.id)
  },
})
```

Data is created through the API rather than the UI. Setting up state through
the interface is slow, fragile, and tests the same paths repeatedly for no
additional information.

The admin session is created once by a setup project and stored, so no test
signs in through the UI except the sign in journey itself.

## Screenshot, only where it carries information

```ts
await expect(page).toHaveScreenshot("members-empty.png", {
  mask: [page.getByTestId("last-updated")],
})
```

One screenshot, of the empty state, because a layout regression there is not
detectable by any assertion above. The volatile timestamp is masked. The email
addresses use the `example.test` domain, which is reserved and obviously
fictional.

## What was verified

```
npx playwright test invitations
  3 passed (18.2s)

npx playwright test invitations   # second consecutive run
  3 passed (17.9s)
```

Two consecutive runs, because one green run does not distinguish a stable test
from a lucky one.

## Findings the journey produced, before it passed

Writing the role based selectors surfaced two real accessibility defects:

```
the Invite member button was a div with onClick, unreachable by keyboard
the dialog had no accessible name, so getByRole("dialog", { name }) failed
```

Both were fixed in the component rather than worked around in the test. This
is the ordinary outcome: the difficulty of writing a good selector is the
signal.
