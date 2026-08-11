# poetry

Poetry. 5 skills. `poet` carries the prosody and is the base for the four
forms.

## The skills

| Skill | Object | Dominant requirement |
|---|---|---|
| [poet](poet/) | French prosody, image, sound, a seven-step procedure | prosodic accuracy |
| [sonnet](sonnet/) | fixed fourteen-line form, rhyme arrangements | the volta in its position |
| [haiku](haiku/) | short form, season, cut | the gap between the images |
| [free-verse](free-verse/) | a form invented and held | every break motivated |
| [prose-poetry](prose-poetry/) | a prose block with no narrative progression | rhythmic control and closure |

## Order of use

`poet` first, always. It carries syllable counting, caesura, rhyme, enjambment
and the work on image. The other four add the constraints of their form.

```
poet
  +-- sonnet         fourteen lines, a volta
  +-- haiku          brevity, season, cut
  +-- free-verse     a constraint invented per poem
  +-- prose-poetry   a block, four cohesion forces
```

## Which skill to open

| Situation | Skill |
|---|---|
| I am writing or revising a poem | `poet` |
| I am checking a syllable count | `poet` |
| I am writing a fixed fourteen-line form | `sonnet` |
| I am writing a short notation or a seasonal collection | `haiku` |
| I am writing free verse | `free-verse` |
| I am writing poetic prose or a fragment | `prose-poetry` |

## The trap of each form

```
sonnet         a decorative volta, placed anywhere
haiku          a pretty image with no gap between its two planes
free-verse     prose cut into lines, with unmotivated breaks
prose-poetry   continuous lyricism, then an explanatory ending
```

Each skill addresses the trap of its own form explicitly. That is what
separates a constraint held from a formal exercise.

## Output language

Prosody is language-specific. `poet` section 2 is French: mute e, dieresis,
hemistich, masculine and feminine rhyme. Set `language.creative_output` to
another language and that section is replaced by the target language's own
metrics, stated explicitly rather than approximated. Everything else, image,
sound, procedure and prohibitions, applies in any language.

## Output

The form's self-critique, then `quality/self-critique-protocol`. For a
collection, `quality/publication-review` last.
