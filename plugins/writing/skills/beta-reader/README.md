# beta-reader

Simulation of real reading across several profiles: engagement map, drop-off
points, confusions, predictions, attachment, cold memory. Symptom collection,
no prescription.

- Inputs: the complete manuscript.
- Outputs: reading report, engagement map.
- Depends on: `writing-constitution`.
- Downstream: `story-doctor`, `literary-critic`.

## When to use

To find out where a reader disengages, and why.

## When not to use

To decide what to change. That is `story-doctor`. Section 5 forbids this skill
from proposing a narrative solution, and the threshold on that axis is 4.

## Why the separation matters

A reader is never wrong about what they felt and almost always wrong about the
fix they suggest. Mixing the two produces a report where the useful data is
buried under advice.

## Configuration

`language.creative_output` sets the output language.
