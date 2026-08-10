# Bisection guide

The defect lives between an input that is correct and an output that is not.
Find the point where correct becomes incorrect, by halving.

## Choosing cut points

A request path has natural cut points. Instrument or inspect at these, not at
every line.

```
1  input received at the boundary
2  input after parsing and validation
3  identity and authorization resolved
4  service entry, arguments
5  query or command constructed
6  query result
7  domain transformation applied
8  response serialised
9  client receives
10 client state updated
11 render output
```

Start at the middle of the suspected range, not at the beginning. Two cuts
divide eleven points into segments of three.

## What to record at each cut

The smallest value that discriminates. Not the whole object.

```
Bad   logger.info("here", { request, user, result })
Good  logger.info("checkout.total", { computed: total, expected: 4900 })
```

The bad version logs a session token and three kilobytes per request. The good
version answers the question.

## Bisecting across time

When the defect is new and the code path is long, bisect the history instead
of the path.

```
git log --oneline -- path/to/suspect/area
git bisect start
git bisect bad HEAD
git bisect good <a revision known to work>
```

Each step runs the reproduction. Five steps cover thirty commits. This is
faster than reading the diff of a release when the release is large.

Requirements: a reliable reproduction command, and a build that works at each
revision. When the build breaks mid range, mark those revisions skipped.

## Bisecting data

When the defect affects some rows and not others, the input space is the
bisection space.

1. Find one failing row and one passing row.
2. List the fields where they differ.
3. Halve the difference list by constructing a test row.

The distinguishing field is almost always null, empty, a boundary value, an
unusual character set, or a relation that is missing.

## Bisecting the environment

When it fails in one environment and not another:

| Difference | Check |
|---|---|
| environment variables | compare the names present, not the values |
| dependency versions | compare the installed tree, not the manifest |
| node or runtime version | read it in both environments |
| data | volume, and rows violating an assumption |
| build artefact | rebuild locally with the production configuration |
| concurrency | one process locally, several in production |
| timezone and locale | the process timezone, not the user timezone |

The environment variable comparison is done on names first. Comparing values
means reading secrets, which is not done.

## When bisection stalls

Two hypotheses remain and the evidence does not separate them. Design one
observation that they predict differently, and make it. Not two changes, one
observation.

If no such observation exists, the two hypotheses are the same hypothesis
described twice, and the cause is elsewhere. Restart at the defect definition,
which is usually where the imprecision was.
