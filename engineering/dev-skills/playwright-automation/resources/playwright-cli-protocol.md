# Browser CLI protocol

For sessions where a browser is driven interactively: QA campaigns, defect
reproduction, evidence capture, debugging a failing test.

The rule that governs everything below: **verify the command surface against
the installed tool before using it**. Versions differ, flags move, and a
command copied from a document that is a year old fails in a way that wastes a
session. Read the help output, then act.

## 1. Availability check, in order

```
1 does the project already configure a browser runner
    read the manifest, the lockfile and the test configuration
2 is a browser CLI already installed and on the path
    ask it for its version, then for its help output
3 is a browser binary already installed for it
4 only then, decide whether anything needs to be installed
```

Do not reinstall a working environment. A campaign that begins with a
gratuitous global install has already changed the machine it was supposed to
observe.

## 2. Installation, when it is genuinely needed

Playwright ships an agent oriented CLI, published as `@playwright/cli`. The
documented entry points at the time of writing:

```
npm install -g @playwright/cli@latest     install the CLI globally
npx playwright-cli                        run it without a global install
playwright-cli install --skills           install the official CLI skills
```

Before running any of these:

```
confirm the package manager the project uses, and prefer it
confirm that a global install is acceptable on this machine, or use npx
confirm the browser to install, from the project support matrix
confirm whether system dependencies are required by this operating system,
  which is usually the case on a bare Linux runner
```

After installing, verify rather than assume:

```
the CLI answers with a version
its help output lists the commands this session needs
a browser launches
a page loads
a screenshot is produced
console output can be read back
the project test suite still runs, if it has one
```

Each of those is a check, not a formality. An installed browser that cannot
launch for want of a system library is the most common failure on a fresh
Linux environment, and it is silent until the first navigation.

## 3. Capabilities to expect

The agent oriented CLI generally provides, under names that vary by version:

```
opening a page and navigating
accessibility snapshots that return element references
clicking, typing and selecting through those references
screenshots, of the page and of an element
console message inspection, filterable by severity
network request inspection, and request interception or mocking
storage and session state: saving, reusing, isolating
video recording, with chapters or markers
tracing
PDF generation
test generation and interactive debugging of failing tests
```

Take the exact command names and flags from the help output of the installed
version. This list is what to look for, not what to type.

## 4. Interaction discipline

```
snapshot, then act on the returned reference
never build a selector from a generated class name
after every action, assert the resulting state before the next action
prefer waiting for a condition over any pause
use a pause only when the tool offers no condition, and note why
one session per role, kept separate, so permissions do not leak between them
never type a real credential into a page that is being recorded
```

## 5. Session hygiene

```
name sessions by role: admin, member, anonymous
store authenticated state once and reuse it, rather than signing in repeatedly
isolate a session when testing anything that touches storage or cookies
close sessions at the end, and delete stored state that contains a token
never commit a stored state file: it holds a live session
```

Add the stored state directory to the project ignore file before creating it,
not after.

## 6. Evidence capture

```
screenshot the state that proves a point, and name the file for that state
record a video only when the evidence is a sequence
chapter a recording by phase, so a reviewer can skip
capture failure states, not only successful ones
redact before saving, never after
```

## 7. Debugging a failing project test

```
1 run the single failing test in isolation
2 read the failure message and the received value
3 attach to the paused test, or open its trace
4 take a snapshot at the failing step and compare it with the expectation
5 read the console and the network at that step
6 decide: application defect, test defect, or environment
7 fix the cause
8 rerun the test, then rerun the file, then rerun the suite once
```

Order matters: reading the trace before changing anything is what separates a
diagnosis from a series of guesses.

## 8. Leaving the machine as it was found

```
remove browsers installed only for this session, if the environment is shared
remove global packages installed only for this session, unless the project
  wants them, in which case they belong in the manifest with a justification
delete stored sessions and downloaded artefacts holding real data
record in the report every tool installed, its version, and why
```
