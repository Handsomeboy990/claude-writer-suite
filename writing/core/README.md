# core

Foundations and production. 14 skills. `writing-constitution` governs the whole
tree; every other skill refers to it and none restates it.

## The skills

### Constitution

| Skill | What it does |
|---|---|
| [writing-constitution](writing-constitution/) | shared non-negotiable rules, conformity grid |

Load it first, before any fiction or poetry.

### Narrative architecture

| Skill | Inputs | Outputs |
|---|---|---|
| [novel-architect](novel-architect/) | premise, genre, length | bible, outline, arcs, reveal schedule |
| [chapter-architect](chapter-architect/) | master outline | chapter sheets, worked titles |
| [scene-builder](scene-builder/) | chapter sheet | written scenes, scene sheets |
| [saga-architect](saga-architect/) | bible of volume 1 | saga bible, cross-volume register |
| [screenwriter](screenwriter/) | pitch or source novel | treatment, breakdown, screenplay |

### Voice and characters

| Skill | Inputs | Outputs |
|---|---|---|
| [narrator](narrator/) | bible | narration charter, voice held |
| [dialogue-master](dialogue-master/) | character sheets | dialogue to French standards |
| [character-psychologist](character-psychologist/) | context, bible | sheets, arcs, relational map |

### World and research

| Skill | Inputs | Outputs |
|---|---|---|
| [world-builder](world-builder/) | genre, research dossier | world bible, lexicon |
| [immersion-director](immersion-director/) | world bible | sensory and cultural dossiers |
| [research-director](research-director/) | outline, period, places | research dossier, source sheets |

### Consistency

| Skill | Inputs | Outputs |
|---|---|---|
| [continuity-manager](continuity-manager/) | written chapters | eight-register record, inconsistency report |
| [timeline-manager](timeline-manager/) | outline, chapters | chronologies, flashback table |

## Order of use

```
writing-constitution
  -> research-director -> world-builder -> immersion-director
  -> character-psychologist
  -> novel-architect -> timeline-manager
  -> chapter-architect -> scene-builder
  -> narrator + dialogue-master
  -> continuity-manager
```

`research-director` before writing about a real trade, period or place.
`continuity-manager` and `timeline-manager` run continuously, not once at the
end.

## Which skill to open

| Situation | Skill |
|---|---|
| I am starting a novel | `novel-architect` |
| I do not know where to cut my chapters | `chapter-architect` |
| My scene is flat | `scene-builder` |
| Every character speaks alike | `dialogue-master` |
| My protagonist is dull | `character-psychologist` |
| My setting reads like a brochure | `immersion-director` |
| I have lost track of the dates | `timeline-manager` |
| I no longer know who knows what | `continuity-manager` |
| I am starting volume 2 | `saga-architect` |
| I am adapting a novel for the screen | `screenwriter` |

## Output

No text produced by a `core` skill is finished before it has passed
`quality/self-critique-protocol`.

## Configuration

`language.creative_output` sets the output language for every skill here.
Templates and reference material in each `resources/` directory are French, as
is the prose these skills produce by default.
