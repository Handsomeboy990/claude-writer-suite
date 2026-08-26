# Test suite review

The suite protects the code. Nothing protects the suite except this review.
Run it when inheriting a project, before a release, and whenever the suite
starts being distrusted.

## Assertions

```
find tests whose only assertion is that nothing threw
find assertions on truthiness where any object would pass
find assertions on a count where the content is what matters
find snapshot assertions covering a whole payload for a three field contract
find assertions on internal calls instead of observable outcomes
find tests asserting the mock rather than the code
```

Test: mutate the code the test covers, deliberately and temporarily. If the
test still passes, it was never protecting anything. Do this on the ten tests
that matter most, at least once per project.

## Coverage of behaviour, not of lines

```
list the features with authorization, and check each has an unauthorized case
list the endpoints with side effects, and check each has a duplicate case
list the forms, and check each has an invalid input case
list the external calls, and check each has a failure case
list the empty states, and check each is asserted somewhere
```

The gaps this produces are the real coverage report. A line coverage number
answers a different question and is often used to avoid this one.

## Determinism

```
run the suite twice in a row, same command: identical results
run it with a different random seed, if the runner supports one
run it in a different order, if the runner supports shuffling
run a single test alone: it must pass
run the suite on a loaded machine: no new failures
grep for sleep, wait, setTimeout, retry, and justify each survivor
grep for the current date, the current time, and Math.random
```

## Isolation

```
does any test depend on data another test created
does any test mutate a module level fixture
does any test leave rows, files, sessions or environment variables behind
does the suite pass on an empty database
does the suite pass twice in a row without a reset between runs
```

## Cost

```
the ten slowest tests, and whether their layer is justified
tests in the browser that could be component tests
tests hitting the network that should hit a stub
the total duration, and whether the team still runs it before pushing
```

A suite that takes long enough to be skipped locally protects nothing until
CI, which is when it is most expensive to fail.

## Skips and quarantine

```
list every skipped test, with the date and the person who skipped it
list every retried test
list every test excluded from CI
```

Each one gets an owner and a date, or it is deleted. A permanently skipped
test is a lie about coverage that survives longer than the defect it hid.

## Report

```
suite      <name>, <count> tests, <duration>
assertions <count> weak, <examples>
behaviour  <features with no unauthorized case>, <endpoints with no duplicate case>
flaky      <named>, with the cause where diagnosed
isolation  <tests that fail alone, or fail when shuffled>
cost       <slowest tests, and the layer they belong in>
skipped    <count>, <owners>, <ages>
verdict    trustworthy | trustworthy with named gaps | not trustworthy, why
```

A suite declared trustworthy without this sheet is declared trustworthy by
habit.
