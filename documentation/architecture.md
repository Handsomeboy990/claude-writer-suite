# Architecture

## Vue d'ensemble

Claude Writer Suite est une bibliothèque de 42 skills organisée en quatre
catégories, plus les ressources partagées, la documentation, un projet de
démonstration et des tests de validation.

```
claude-writer-suite/
├── CLAUDE.md
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── LICENSE
├── core/          14 skills
├── genres/        15 skills
├── poetry/         5 skills
├── quality/        8 skills
├── resources/
├── examples/
├── documentation/
└── tests/
```

## Principe d'isolation

Un skill égale un dossier. Aucun skill ne dépend du contenu interne d'un
autre : il en consomme uniquement les sorties déclarées dans son bloc de
métadonnées. Cette règle permet d'ajouter, de remplacer ou de supprimer un
skill sans casser la suite.

Structure obligatoire :

```
skill-name/
├── SKILL.md      système d'expertise, document principal
├── README.md     résumé, entrées, sorties, dépendances
├── examples/     au moins un exemple appliqué
└── resources/    au moins une grille, checklist ou référence
```

## Métadonnées

Chaque `SKILL.md` s'ouvre par un bloc YAML :

```yaml
---
name: nom-du-skill
description: Ce que fait le skill, puis quand l'utiliser, avec les termes qui
  doivent le déclencher.
license: MIT
metadata:
  category: core | genres | poetry | quality
  version: 1.0.0
  depends_on: [liste des skills requis]
  outputs: [artefacts produits]
---
```

Les champs `name` et `description` sont au premier niveau : ils sont requis
pour que le skill soit découvert et chargé par un agent. Le champ `name` doit
être identique au nom du dossier. Les métadonnées propres au projet sont
regroupées sous `metadata`, où elles n'interfèrent pas avec le chargement.

## Catégories

### core, 14 skills

Fondations et production. `writing-constitution` domine toute la suite.

writing-constitution, novel-architect, chapter-architect, scene-builder,
narrator, dialogue-master, character-psychologist, world-builder,
immersion-director, research-director, continuity-manager, timeline-manager,
saga-architect, screenwriter.

### genres, 15 skills

Spécialisations. Chacune hérite de la constitution et ajoute un contrat de
lecture, des codes, des interdits et des axes d'auto-critique propres.

thriller, mystery, detective, horror, fantasy, dark-fantasy, science-fiction,
cyberpunk, historical-fiction, romance, adventure, dystopian,
political-fiction, espionage, magical-realism.

### poetry, 5 skills

poet porte la prosodie française et sert de socle aux quatre formes.

poet, sonnet, haiku, free-verse, prose-poetry.

### quality, 8 skills

Contrôle et révision. `self-critique-protocol` est obligatoire en sortie de
tout skill de production.

self-critique-protocol, story-doctor, literary-editor, literary-critic,
proofreader, beta-reader, rewriting-engine, publication-review.

## Graphe de dépendances

```
writing-constitution
        |
        +-- research-director --> world-builder --> immersion-director
        |                              |
        +-- character-psychologist ----+
        |                              |
        +-- novel-architect -----------+--> timeline-manager
                    |                            |
                    +--> chapter-architect --> scene-builder
                    |                            |
                    +--> saga-architect          +--> narrator
                    |                            +--> dialogue-master
                    +--> screenwriter
                                                 |
                              continuity-manager <+
                                                 |
                          self-critique-protocol <+
                                    |
        story-doctor <--------------+--------------> beta-reader
             |                                            |
        rewriting-engine                            literary-critic
             |                                            |
        literary-editor --> proofreader --> publication-review
```

## Ressources partagées

`resources/` contient ce qui serait dupliqué autrement : typographie,
structures narratives, lexiques, gabarits de démarrage et de suivi. Un skill
y renvoie, il n'en recopie jamais le contenu.

## Tests

`tests/` contient deux scripts sans dépendance externe :

- `validate-structure.sh` vérifie la présence des fichiers et dossiers
  obligatoires de chaque skill, ainsi que le bloc de métadonnées.
- `validate-rules.sh` vérifie les interdits de la constitution sur tout le
  repository : emoji, tiret cadratin, guillemets droits, majuscules
  d'emphase.

## Extension

Ajouter un skill suppose : créer le dossier avec ses quatre éléments, déclarer
les métadonnées, renvoyer à la constitution sans la recopier, ajouter au moins
un exemple et une ressource, mettre à jour `documentation/skills-guide.md`,
puis exécuter les deux scripts de test.
