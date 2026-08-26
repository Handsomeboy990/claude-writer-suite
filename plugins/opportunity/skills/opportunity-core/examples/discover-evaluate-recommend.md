# Example: the method, on a side-project idea search

A developer with weekends free wants a side project that could earn money. The
opportunity method runs in three steps; the middle and last are where the value is.

## The actor

```
skills      backend (Go, Postgres), some frontend, no design, no marketing reach
time        ~8 hours a week, sustainable for a few months
resources   no budget to speak of, no audience
goal        a small revenue stream, not a startup; something shippable solo
binding     the constraint that dominates: solo, part-time, no marketing reach
```

## Step 1: discover (the easy, divergent half)

```
a dozen premises generated broadly: a niche API, a devtool, a content site, a
Chrome extension, a SaaS for a hobby community, a paid newsletter tool, ...
```

This list is raw material, not an answer. Left here, it is a dozen equally
weightless options.

## Step 2: evaluate against the binding constraint

```
criteria     shippable solo part-time, reachable audience without marketing spend,
             a real problem someone pays for, low ongoing operational burden

niche API           feasible solo; but "reachable audience without marketing" fails
                    unless it sits on an existing marketplace -> keep only the
                    marketplace-hosted variants
Chrome extension    feasible; distribution via the store is the reachable audience
                    -> passes the binding constraint
SaaS for a hobby    feasible; but reaching the community needs marketing reach the
                    developer lacks -> fails the binding constraint, out
content site        low technical fit to the skills, slow to earn -> out
```

The binding constraint (no marketing reach) eliminated half the list, including
the most exciting-sounding one, because a great idea the actor cannot distribute
is a bad recommendation for this actor.

## Step 3: recommend a ranked few, with reasoning and next steps

```
1  a paid Chrome extension solving a specific annoyance in a tool with a store
   presence: distribution is the store, feasible solo, low ops burden.
   next step: validate the annoyance is real and unmet by searching the store's
   reviews and the tool's forum before writing code (an idea-evaluation task).

2  a small paid API on an existing API marketplace: the marketplace is the
   reachable audience; feasible solo.
   next step: check the marketplace for demand signals and existing competition.

rejected, with why:
   the hobby-community SaaS (no distribution channel), the content site (poor
   skill fit and slow to earn); shown so the developer sees the space was explored.
```

## The lesson

The dozen ideas were the third of the work that felt productive. The
recommendation came from the two thirds that followed: evaluating against the one
constraint that actually binds this actor, and reporting the reasoning. Two
grounded next steps beat a brainstorm of twelve.
