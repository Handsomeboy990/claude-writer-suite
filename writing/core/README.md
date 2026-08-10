# core

Fondations et production. 14 skills. `writing-constitution` domine toute la
suite ; tous les autres y renvoient sans jamais la recopier.

## Les skills

### Constitution

| Skill | Ce qu'il fait |
|---|---|
| [writing-constitution](writing-constitution/) | règles communes non négociables, grille de conformité |

À charger en premier, avant toute écriture de fiction ou de poésie.

### Architecture du récit

| Skill | Entrées | Sorties |
|---|---|---|
| [novel-architect](novel-architect/) | prémisse, genre, longueur | bible, plan, arcs, calendrier des révélations |
| [chapter-architect](chapter-architect/) | plan général | fiches chapitre, titres travaillés |
| [scene-builder](scene-builder/) | fiche chapitre | scènes rédigées, fiches de scène |
| [saga-architect](saga-architect/) | bible du tome 1 | bible de saga, registre inter-tomes |
| [screenwriter](screenwriter/) | pitch ou roman source | traitement, séquencier, continuité dialoguée |

### Voix et personnages

| Skill | Entrées | Sorties |
|---|---|---|
| [narrator](narrator/) | bible | charte de narration, point de vue tenu |
| [dialogue-master](dialogue-master/) | fiches personnages | dialogues aux normes françaises |
| [character-psychologist](character-psychologist/) | contexte, bible | fiches, arcs, cartographie relationnelle |

### Monde et documentation

| Skill | Entrées | Sorties |
|---|---|---|
| [world-builder](world-builder/) | genre, dossier documentaire | bible du monde, lexique |
| [immersion-director](immersion-director/) | bible du monde | dossiers sensoriels et culturels |
| [research-director](research-director/) | plan, époque, lieux | dossier documentaire, fiches sources |

### Cohérence

| Skill | Entrées | Sorties |
|---|---|---|
| [continuity-manager](continuity-manager/) | chapitres rédigés | registre en huit volets, rapport d'incohérences |
| [timeline-manager](timeline-manager/) | plan, chapitres | chronologies, table des flashbacks |

## Ordre d'usage

```
writing-constitution
  -> research-director -> world-builder -> immersion-director
  -> character-psychologist
  -> novel-architect -> timeline-manager
  -> chapter-architect -> scene-builder
  -> narrator + dialogue-master
  -> continuity-manager
```

`research-director` avant d'écrire sur un métier, une époque ou un lieu réel.
`continuity-manager` et `timeline-manager` tournent en continu, pas une fois à
la fin.

## Quel skill ouvrir

| Situation | Skill |
|---|---|
| Je démarre un roman | `novel-architect` |
| Je ne sais pas où couper mes chapitres | `chapter-architect` |
| Ma scène est plate | `scene-builder` |
| Tous mes personnages parlent pareil | `dialogue-master` |
| Mon protagoniste est fade | `character-psychologist` |
| Mon décor sonne comme un dépliant | `immersion-director` |
| Je perds le fil des dates | `timeline-manager` |
| Je ne sais plus qui sait quoi | `continuity-manager` |
| Je lance un tome 2 | `saga-architect` |
| J'adapte un roman à l'écran | `screenwriter` |

## Sortie

Aucun texte produit par un skill `core` n'est terminé avant le passage par
`quality/self-critique-protocol`.
