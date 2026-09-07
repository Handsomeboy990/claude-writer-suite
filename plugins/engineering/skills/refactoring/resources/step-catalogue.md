# Step catalogue

Each step is small enough to undo, and ends with a green suite.

## Naming

```
rename a local            no risk, do it while reading
rename a private symbol   mechanical, one commit
rename a public symbol    two releases: add the new name as an alias, migrate
                          callers, remove the old one
rename a file or module   one commit, imports only
```

## Structure

```
extract function          when a block has a name in your head already
inline function           when the name adds nothing the call site lacks
extract module            when two responsibilities change for different
                          reasons
move function             to the module that owns the data it touches
split a large function    by the comments already dividing it
merge two modules         when neither can change without the other
```

## Dependencies

```
introduce a parameter     replace a global or an import with an argument
introduce an interface    only when a second implementation exists
invert a dependency       when the low level module imports the high level one
remove a dependency       when one function of a library is used once
```

## Conditionals

```
guard clause              replace nested conditions with early returns
lookup table              replace a long chain comparing one value
polymorphism              only when the same chain appears in three places
extract predicate         name the condition, especially a compound one
```

## Data

```
introduce a type          replace primitives that travel together
encapsulate a field       when invariants exist on it
replace a magic value     with a named constant, at the point of definition
normalise a shape         when two parts of the code disagree about a field
```

## The rule of three

Duplication is extracted at the third occurrence, not the second. Two similar
blocks are often two things that resemble each other today; the third proves a
shared concept.

An abstraction introduced too early is harder to remove than the duplication
it replaced, because it acquires callers.

## Step sizing

```
good      one step, one concept, under fifteen minutes, suite green
warning   a step that requires editing more than five files mechanically
stop      a step that cannot be described in one sentence
stop      a step where the suite cannot run until it is finished
```

If a step cannot keep the suite green, split it into two: make the new
structure exist alongside the old, migrate callers, remove the old.

## The parallel change pattern

For anything that cannot move in one step:

```
1 introduce the new structure beside the old
2 make the old delegate to the new, or write to both
3 migrate callers, a few per commit, suite green each time
4 remove the old structure
5 remove any compatibility shim
```

Steps 4 and 5 are the ones that get forgotten, which is how a codebase ends up
with three generations of the same idea. Schedule them in the same working
session, or record them as an explicit debt item.
