# Selector policy

A selector is a contract with the interface. A good one breaks when the
interface breaks and survives everything else.

## Order of preference

### 1. Role and accessible name

```ts
page.getByRole("button", { name: "Send invitation" })
page.getByRole("textbox", { name: "Email address" })
page.getByRole("dialog", { name: "Invite a member" })
page.getByRole("row", { name: /ada@example.com/ })
```

This is first because it fails exactly when a screen reader user would fail.
A button that loses its accessible name breaks the test, and that is the
correct outcome.

### 2. Label

```ts
page.getByLabel("Email address")
page.getByLabel("Role")
```

### 3. Text

```ts
page.getByText("No invitations yet")
```

Use for content that is part of the product contract. Do not use for
incidental copy that a writer will change next week.

### 4. Deliberate test identifier

```ts
page.getByTestId("revenue-chart")
```

For elements with no accessible identity: a canvas, a chart container, a
virtualised viewport. Added on purpose, named after the concept, never
sprinkled everywhere as a shortcut around bad markup.

## Banned

```ts
page.locator(".btn.btn-primary.mt-4")        // styling change breaks it
page.locator("div > div:nth-child(3) > span") // any markup change breaks it
page.locator("//div[@class='card'][2]")       // unreadable and positional
page.locator("#\\:r3\\:")                     // generated identifier
page.locator("text=Save").nth(2)              // position dependent
```

Each of these produces a test that fails for reasons unrelated to behaviour,
which is how a suite loses its credibility.

## Scoping instead of chaining

When a name is ambiguous, scope to the container rather than adding position.

```ts
// Ambiguous: three rows have a Remove button
const row = page.getByRole("row", { name: /ada@example.com/ })
await row.getByRole("button", { name: "Remove" }).click()
```

The scoped version reads like the user's intention: the Remove button in Ada's
row. The positional version, `nth(1)`, breaks when sorting changes.

## When the selector is hard to write

That is a finding, not an obstacle. It usually means:

- an interactive element is a `div` with a click handler;
- an input has no label;
- an icon only button has no accessible name;
- a dialog has no accessible name;
- identical link text repeats across rows.

Each of these is an accessibility defect that a real user meets. Fix the
markup, then the selector becomes obvious. The test difficulty was the signal.

## Assertions follow the same rule

```ts
// Good: asserts what the user perceives
await expect(page.getByRole("alert")).toHaveText("Invitation sent")
await expect(page.getByRole("row", { name: /ada@example.com/ })).toBeVisible()

// Bad: asserts implementation detail
await expect(page.locator(".toast-success")).toHaveCount(1)
```
