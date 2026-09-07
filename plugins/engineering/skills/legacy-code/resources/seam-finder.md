# Seam finder

A seam is where behaviour can be replaced without editing the surrounding
code. Work down this list and take the first one that exists.

## Existing seams

| Seam | Looks like | Use |
|---|---|---|
| parameter | the dependency is an argument | pass a double |
| constructor | the class receives its collaborators | construct with doubles |
| factory or container | something builds the dependency | register a double |
| module import | the code imports a module by name | intercept the module |
| network | the code makes an HTTP or database call | stub at the boundary |
| environment | behaviour branches on configuration | set it in the test |
| clock and randomness | the code calls now or random directly | inject or freeze |
| filesystem | the code reads a path | point it at a temporary directory |

## Creating a seam, in order of preference

```
1 extract the untestable statement into a function, and pass it in
2 extract the whole side effecting block into a collaborator
3 introduce a parameter with a default, so no caller changes
4 wrap the global, and use the wrapper everywhere in this file
```

Each of those is a `refactoring` step: no behaviour change, suite green, its
own commit.

## The hardest cases

```
static call to a singleton    wrap it once, inject the wrapper
a constructor that does work  extract the work into an initialise method
a god object                  test through its public boundary first, split later
code that touches five
  boundaries in one function  extract one at a time, over several commits
generated code                do not edit it, test the code that calls it
a framework entry point       test the layer beneath it, and cover the entry
                              point with one browser or contract test
```

## What to do when there is no seam and no time

Record it honestly rather than pretending:

```
change site      lib/billing/legacy_invoice.rb, method render_totals
seam             none available without extracting three collaborators
mitigation       manual verification on four real invoices, output compared
                 against a captured baseline, evidence attached
risk             any change here is unprotected. Recorded in the risk
                 register and in the continuity notes.
next step        extract the currency formatter, which is the smallest
                 useful seam, estimated one hour
```

That is a legitimate professional result. Silence is not.

## Capturing a baseline when a test is impossible

```
1 collect real inputs from logs or a database copy, redacted
2 run the current code on them and store the outputs
3 make the change
4 run the new code on the same inputs
5 compare, byte for byte where possible, field by field otherwise
6 investigate every difference, including the ones that look like improvements
```

This is a characterization test performed by hand. It works, it is slow, and
it belongs in the report so the next person can repeat it.
