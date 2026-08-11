---
name: screenwriter
description: Writes a screenplay: pitch, synopsis, treatment, scene breakdown, full script, standard format, feature and series structure, adaptation of a novel. Use to write or adapt a screenplay, or to convert novelistic interiority into visible action.
license: MIT
metadata:
  category: core
  version: 2.0.0
  depends_on: [writing-constitution, scene-builder, dialogue-master]
  outputs: [treatment, scene-breakdown, screenplay]
---

# Screenwriter

Screenwriting: feature, series, adaptation of a novel. A screenplay is not a
novel cut into pieces: it has access only to what is seen and what is heard.

## 1. Founding constraint

Anything neither visible nor audible does not exist. Thoughts, memories and
intentions must be translated into actions, objects, looks, silences.

Conversion test: take a paragraph of the novel, remove everything that belongs
to interiority, and see what remains. What remains is the starting point of
the scene.

## 2. Stages of the work

1. Pitch: one sentence.
2. Synopsis: two to five pages, present tense, no dialogue.
3. Treatment: sequence by sequence, present tense, dominant actions, a few key
   lines.
4. Scene breakdown: a numbered table with place, time, characters, objective,
   conflict, exit.
5. Screenplay: the full script.

Never write the script before the breakdown holds.

## 3. Format

Scene heading: interior or exterior, place, time.

```
INT. BUREAU DU CHEF DE SECTEUR - JOUR

Un ventilateur brasse de l'air chaud. SABINE, 41 ans, pose un dossier sur le
bureau, de biais.

                    SABINE
          Trois villages. Deux mille personnes.

                    KABEYA
          Vous avez l'ordre de la direction ?
```

Rules:

- Present tense, third person.
- A character is capitalised on their first appearance only.
- No shot or camera movement indications, unless absolutely necessary.
- No psychological stage direction: `il pense à sa mère` is inadmissible.
- One page is roughly one minute.

## 4. Structure

Feature, one hundred and ten pages:

- Opening sequence, pages 1 to 10: the world and the lack.
- Inciting incident, page 12.
- End of act 1, page 27: the protagonist commits.
- Midpoint, page 55: reversal.
- End of act 2, page 85: everything is lost.
- Climax, pages 95 to 105.
- Resolution, pages 105 to 110.

Series: add, per episode, a closed question answered at the end of the
episode, and a season question that stays open. See `saga-architect` for
multi-season logic.

## 5. The screenplay scene

Every scene sits on four lines of preparation: where, who wants what, what
obstacle, what exit. A scene longer than three pages must be justified.

Techniques:

- open on an object that states the situation;
- cut the scene on the line that unbalances, not on the answer;
- leave the camera on a character who is not speaking;
- use the off-screen for what would be expensive or complacent.

## 6. Screenplay dialogue

Differences from the novel:

- no incise; the character name replaces the speech verb;
- shorter lines, four at most;
- orality is more marked, but still written: real hesitations are cut;
- subtext matters even more, because no narrator compensates.

The constitution's rules on emoji, em dashes, cliches and cultures apply in
full.

## 7. Adapting a novel

Protocol:

1. Identify the dramatic question of the novel.
2. List the scenes that advance that question. The others go.
3. Merge redundant characters.
4. Convert every major interiority into action or conflict.
5. Move the reveals to hold the rhythm of the structure.
6. Accept losing the prose: it is replaced by staging, framing and editing.

## 8. Auto-critique

Score 0 to 5: visual clarity, absence of untranslated interiority,
effectiveness of scene entries and exits, structure, page rhythm, quality of
dialogue, subtext, economy of characters, format.

Threshold: no axis below 3, average at least 3.8.

## 9. Interfaces

- Upstream: `novel-architect`, `character-psychologist`.
- Lateral: `scene-builder`, `dialogue-master`.
- Review: `quality/story-doctor`.
