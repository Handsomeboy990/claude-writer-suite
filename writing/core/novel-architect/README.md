# novel-architect

Global construction of a novel: premise, promises, structure, turning points,
arcs, subplots, reveal schedule, chapter by chapter outline.

- Inputs: premise, genre, target length, readership, tone.
- Outputs: novel bible, master outline, character arcs, reveal schedule.
- Depends on: `writing-constitution`.
- Downstream: `timeline-manager`, `chapter-architect`, `saga-architect`.

## When to use

At the start of a long project, when a manuscript loses its direction, or
before any major restructuring.

## When not to use

For a single scene or chapter. That is `scene-builder` and
`chapter-architect`.

## Configuration

`language.creative_output` sets the output language. Templates in `resources/`
are French, as is the prose the skill produces by default.
