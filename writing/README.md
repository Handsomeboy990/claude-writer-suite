# writing

Creative writing. 42 skills in four categories, plus shared resources and a
complete demonstration project.

Skill language: English. Default output language: French, set by
`language.creative_output`. Governed by `core/writing-constitution`.

## Categories

| Category | Skills | Purpose |
|---|---|---|
| [core](core/) | 14 | foundations and production |
| [genres](genres/) | 15 | genre specialisations |
| [poetry](poetry/) | 5 | poetic forms |
| [quality](quality/) | 8 | review and revision |

Each has its own index. Start with
[core/writing-constitution](core/writing-constitution/), which governs the
whole tree.

## Why the skills are English and the output is French

The craft encoded here is French: dialogue typography, incise inversion,
alexandrine scansion, agreement rules, the cliche list. Writing those
instructions in English makes the system usable by anyone; writing the output
in French is what the expertise is for.

Set `language.creative_output` to another language and the structural rules
still apply in full. The typographic and prosodic rules are French
conventions, and the affected skills say so and require the target language's
own rules rather than approximating from French.

The material in `resources/` and in each skill's `resources/` and `examples/`
stays French. It is reference data and worked samples of French prose, which
is what the skills produce rather than how they are instructed.

## Shared resources

- [resources/](resources/): French typography, narrative structures, lexicons,
  project templates. A skill refers to them and never copies their content.
- [examples/](examples/): `saga-les-cendres-de-kivu`, a complete demonstration
  project, from the bible to the validation report.

## Recommended workflow

```
research-director  ->  world-builder  ->  character-psychologist
        ->  novel-architect  ->  timeline-manager
        ->  chapter-architect  ->  scene-builder
        ->  narrator + dialogue-master + immersion-director
        ->  self-critique-protocol
        ->  story-doctor  ->  literary-editor  ->  proofreader
        ->  beta-reader  ->  literary-critic  ->  publication-review
```

The eleven phases are detailed in `documentation/workflow.md`.

Golden rule: no text is finished before it has passed
`quality/self-critique-protocol` and then at least one revision skill.

## Minimum chain for one chapter

```
chapter-architect -> scene-builder -> dialogue-master
    -> self-critique-protocol -> continuity-manager
```

## Shared rules

Non-negotiable, defined in `core/writing-constitution/SKILL.md`:

no emoji, no em dash, dialogue conforming to French publishing standards,
flashbacks in italic and clearly separated from the main line, a chronology the
reader can always follow, worked chapter titles, consistent characters, natural
prose, cliches refused, show rather than explain, embodied emotion, respect for
the cultures represented, no tolerated inconsistency.

The first two apply to every file in this repository, the engineering tree
included.

Every production skill ends with an eleven-axis self-assessment and a numeric
delivery threshold.

## Choosing a skill

| Situation | Skill to open |
|---|---|
| I am starting a project | `resources/templates/demarrage-de-projet.md`, then `core/novel-architect` |
| I do not know where to cut my chapters | `core/chapter-architect` |
| My scene is flat | `core/scene-builder` |
| My dialogue all sounds the same | `core/dialogue-master` |
| My middle does not move | `quality/story-doctor` |
| I have lost track of the dates | `core/timeline-manager` |
| I no longer know who knows what | `core/continuity-manager` |
| My text is correct but flat | `quality/literary-editor` |
| I want to know whether it is publishable | `quality/literary-critic` |

The full table is in `documentation/skills-guide.md`.

## Installation

```bash
bash install.sh --writing     the 42 writing skills, plus the shared pair
```

## Relation to the other trees

None, beyond the two typographic prohibitions and the shared Git rules. No
writing skill depends on an engineering or a documents skill, and the reverse
holds.

The two cross domain skills apply here as everywhere: `shared/project-brief`
frames a book project, and `shared/self-critique` delegates to
`quality/self-critique-protocol` for creative text, because these axes and
thresholds are more demanding than any general panel.
