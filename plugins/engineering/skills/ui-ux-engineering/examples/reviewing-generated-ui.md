# Example: reviewing generated UI before it lands

A pricing table was produced by a UI generation tool and pasted into a pull
request. It looks correct in the screenshot. Here is what the review found.

## The generated markup, abridged

```tsx
<div className="grid grid-cols-3 gap-8 p-12">
  {plans.map((plan) => (
    <div className="rounded-2xl border p-8 shadow-lg" key={plan.name}>
      <div className="text-sm text-gray-400">{plan.name}</div>
      <div className="mt-4 text-5xl font-bold">${plan.price}</div>
      <div className="mt-2 text-gray-400">per month</div>
      <div
        className="mt-8 cursor-pointer rounded-lg bg-indigo-600 py-3
                   text-center text-white hover:bg-indigo-700"
        onClick={() => selectPlan(plan)}
      >
        Choose {plan.name}
      </div>
      <ul className="mt-8 space-y-3">
        {plan.features.map((f) => (
          <li className="flex gap-2 text-sm text-gray-400" key={f}>
            <CheckIcon className="text-green-400" /> {f}
          </li>
        ))}
      </ul>
    </div>
  ))}
</div>
```

## Findings

**1. The call to action is not a button.** A `div` with `onClick` and
`cursor-pointer`. Unreachable by keyboard, invisible to assistive technology,
no focus state, no activation on Enter or Space. This is the defect that makes
the component unusable rather than merely imperfect.

**2. Contrast below target.** `text-gray-400` on the card background measures
2.9 to 1. The project target is 4.5 to 1 for body text. Three of the four text
elements fail, including the feature list, which is the content the page
exists to communicate.

**3. Tokens invented.** `gap-8`, `p-12`, `rounded-2xl`, `shadow-lg`,
`text-5xl` and `bg-indigo-600` are not the project's values. The project uses
a four point spacing scale, a defined radius token and a brand colour that is
not indigo. The card would be visibly foreign next to every other card in the
product.

**4. No responsive behaviour.** `grid-cols-3` at every width. At 320 pixels
each column is roughly 80 pixels wide and the price wraps mid number.

**5. Price rendered as a raw value with a hardcoded currency symbol.** `$` in
markup, `plan.price` presumably a float. The product sells in three
currencies.

**6. No states.** No loading, no error, no selected state, no disabled state
for the plan the user is already on. The list of plans arrives asynchronously,
so the first render is an empty grid with padding.

**7. Meaning by colour alone.** The green check is the only signal that a
feature is included. In a variant where some features are excluded, the design
would rely entirely on the icon colour.

**8. No accessible structure.** The three cards are anonymous divs. A screen
reader user gets a wall of text with no way to tell where one plan ends and
the next begins.

## The corrected version

```tsx
<ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
  {plans.map((plan) => (
    <li key={plan.id}>
      <article
        aria-labelledby={`plan-${plan.id}`}
        className="rounded-md border border-border bg-surface p-6"
      >
        <h3 id={`plan-${plan.id}`} className="text-sm text-muted">
          {plan.name}
        </h3>

        <p className="mt-2 text-3xl font-semibold tabular-nums">
          {formatMoney(plan.priceMinor, plan.currency)}
          <span className="text-sm font-normal text-muted"> per month</span>
        </p>

        <Button
          className="mt-6 w-full"
          onClick={() => selectPlan(plan)}
          disabled={plan.id === currentPlanId}
        >
          {plan.id === currentPlanId ? "Current plan" : `Choose ${plan.name}`}
        </Button>

        <ul className="mt-6 space-y-2 text-sm text-body">
          {plan.features.map((f) => (
            <li key={f.id} className="flex gap-2">
              <CheckIcon aria-hidden className="text-success" />
              <span>{f.label}</span>
            </li>
          ))}
        </ul>
      </article>
    </li>
  ))}
</ul>
```

Changes, each tied to a finding: the project `Button` component replaces the
div, tokens replace invented values, the grid is responsive from one column
up, money is formatted from minor units and a currency, the current plan is a
disabled state with an explanation in its own label, headings and an
`aria-labelledby` give each card an accessible name, the icon is hidden from
assistive technology since the adjacent text carries the meaning, and
`text-body` and `text-muted` are tokens that meet contrast on both themes.

The loading and error states live in the parent, which renders three skeleton
cards of the same height while the plans load.

## Verification

```
Contrast, light theme:  body 7.1, muted 4.6, button label 8.2   pass
Contrast, dark theme:   body 8.4, muted 4.7, button label 7.9   pass
Keyboard:               tab reaches all three buttons, focus visible,
                        Enter and Space activate, disabled button skipped
Widths 320 / 768 / 1440: one, two, three columns, no horizontal scroll
Automated scan:         0 violations
```

## The rule this illustrates

Generated UI is a starting point for the markup, not a decision about the
product. Eight findings on forty lines is a normal yield, and every one of
them is cheaper to fix before the component is copied into four other screens.
