# Example: refactoring a pricing function with no tests

The motivating change: add a second discount type. The current function is 180
lines, has eleven branches, and no tests.

## Step 0, the reason, written down

```
Adding a discount type currently requires touching four branches and reading
all 180 lines to be sure nothing else applies. Two defects in the last year
came from that. Goal: make adding a discount type a local change.
```

## Step 1, characterization tests

Not what the function should do. What it does.

```ts
describe("computeTotal, characterization", () => {
  const cases = [
    { name: "single item, no discount",     input: {...}, expect: 1200 },
    { name: "percentage discount",          input: {...}, expect: 1080 },
    { name: "fixed discount above total",   input: {...}, expect: 0 },
    { name: "fixed discount, negative",     input: {...}, expect: -300 },
    // ^ this is wrong. It is asserted anyway, and marked.
    { name: "two discounts, both applied",  input: {...}, expect: 972 },
    { name: "zero quantity line",           input: {...}, expect: 1200 },
    { name: "rounding, three items at 3.33",input: {...}, expect: 999 },
  ]
  cases.forEach(({ name, input, expect: total }) =>
    it(name, () => expect(computeTotal(input)).toBe(total)))
})
```

The fourth case records a defect: a fixed discount larger than the total
produces a negative amount. It is asserted exactly as it behaves today,
because the job of this suite is to detect change, not to bless behaviour.

Seven cases, thirty minutes, and now the function can be moved safely.

## Steps 2 to 7, one commit each

```
2  extract the line total computation, unchanged            green
3  extract the percentage discount branch                   green
4  extract the fixed discount branch                        green
5  introduce a Discount type with an apply function         green
6  replace the branch chain with an ordered list of
   discount handlers                                        RED
```

Step 6 went red on the case `two discounts, both applied`. The old chain
applied percentage before fixed; the list preserved declaration order, which
was the opposite. The step was undone and redone with the order made explicit
and documented, because that ordering is behaviour that a customer sees.

```
6' ordered list, order stated and tested explicitly         green
7  inline the two now-trivial wrappers                      green
```

## Proof of equivalence

```
suite green before: 7 characterization tests, all passing
suite green after:  7 characterization tests, all passing, unmodified
diff:               computeTotal from 180 lines to 24, plus 3 handlers
public signature:   unchanged
performance:        not hot, not measured, stated as such
```

The characterization tests were never edited. That is the whole proof.

## Then, and only then, the behaviour changes

Two further commits, each with its own test:

```
commit A  fix the negative total defect
          the characterization test for that case is updated deliberately,
          with the reason in the message, and a new test asserts the total
          floors at zero
commit B  add the new discount type
          one file, one handler, one test. Which was the point of all of the
          above.
```

Commit B is nine lines. Reaching a place where it could be nine lines took six
commits and an hour, and that hour is the reason the next discount type will
also be nine lines.
