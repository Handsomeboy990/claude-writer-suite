# Flaky test guide

A flaky test means one of two things is wrong: the test, or the code. Until
that is decided, the information is valuable and must not be thrown away.

## Never do this

```
test.retry(3)
test.skip("flaky, fix later")
await page.waitForTimeout(2000)
delete the test
```

Each of these converts a signal into silence. The third one is the worst,
because it appears to fix the problem and makes the suite slower forever.

## Diagnosis order

**1. Is it a real race in the code?**

Ask whether the flake describes a sequence that a user could produce. Two
requests, a click during a pending mutation, a job overlapping its previous
run. If yes, the test found a production defect and the fix belongs in the
code.

This is checked first because it is the case that matters and the case that
gets dismissed fastest.

**2. Shared state between tests.**

Symptom: passes alone, fails in the suite; passes in one order, fails in
another.

```
run the test alone
run the file alone
run the suite with a fixed seed and with a shuffled order
```

Cause is usually a module level variable, a shared database row, a cache not
cleared, or a stub not restored.

**3. Time.**

Symptom: fails near midnight, at month end, in another timezone, or once per
run.

Cause: the real clock, a duration compared in the wrong unit, an expiry
computed at test setup and evaluated later, a timezone difference between the
test process and the database.

Fix: freeze the clock. Fixed instants, not offsets from now.

**4. Randomness.**

Unseeded random data, or a factory generating values that occasionally collide
with a unique constraint. Seed it, and log the seed on failure so the failure
is reproducible.

**5. Asynchrony in the test.**

An assertion running before the effect settles. In browser tests, waiting for
a timeout rather than for a condition.

```
Bad   await page.waitForTimeout(1000); expect(row).toBeVisible()
Good  await expect(row).toBeVisible()
```

The good version waits for the condition, with a bounded timeout, and fails
fast when the condition is wrong rather than slow when the machine is loaded.

**6. Environment.**

Parallel workers sharing one database, a port collision, a machine slower than
the developer's, animation still running.

Fix: isolate per worker, disable animations in the test environment, and stop
asserting on durations.

## After the fix

Run the test twenty times in a row and record the result. One green run does
not distinguish a fixed test from a lucky one.

```
for i in $(seq 1 20); do npm test -- invitations || break; done
```

## Recording

A flake that was diagnosed as a real race gets a regression test named after
the race, and the defect is reported through `debugging`, not silently
absorbed into the test fix.

A flake that was diagnosed as a test defect gets a one line note in the test
explaining the trap, so the next person does not reintroduce it.
