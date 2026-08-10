# Architecture

## Vue d'ensemble

Claude Writer Suite est une bibliothèque de 83 skills organisée en sept
catégories, plus quatorze agents, les ressources partagées, la documentation,
un projet de démonstration et des tests de validation.

Les quatre premières catégories forment la suite d'écriture. Les trois
suivantes forment le système d'ingénierie et de livraison, documenté dans
`engineering-system.md` et `delivery-system.md`. Les deux systèmes partagent
la structure de skill, les tests et les règles Git, et ne se croisent pas :
aucun skill de l'un ne dépend d'un skill de l'autre.

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
├── dev-skills/    20 skills
├── delivery-skills/ 10 skills
├── devops-skills/  11 skills
├── agents/         14 agents
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
            | dev-skills | delivery-skills | devops-skills
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

### dev-skills, 20 skills

Ingénierie logicielle, agnostique de la pile technique. `engineering-core`
domine le système, `engineering-orchestrator` le route. Contenu rédigé en
anglais, pour les raisons exposées dans `engineering-system.md` section 2.

engineering-core, project-exploration, engineering-orchestrator,
architecture-design, ui-ux-engineering, dependency-selection,
frontend-engineering, backend-engineering, fullstack-engineering,
input-validation, security-audit, debugging, testing-quality,
playwright-automation, performance-engineering, code-review-protocol,
technical-documentation, project-continuity, git-workflow, release-readiness.

Le graphe de dépendances de cette catégorie figure dans
`engineering-system.md` section 7, avec les portes obligatoires et les
catégories de tâches.

### delivery-skills, 10 skills

Conduite d'un projet de la spécification à la livraison.
`delivery-orchestrator` tient les quatorze phases et leurs portes
d'approbation.

delivery-orchestrator, requirements-analysis, clarification-gate,
technology-selection, architecture-proposal, validation-gate,
delivery-planning, implementation-integrity, scope-and-change-control,
client-handover.

### devops-skills, 11 skills

Exploitation, agnostique de la plateforme. `devops-core` domine la famille.

devops-core, environment-management, secrets-management, containerization,
ci-cd-pipelines, deployment-engineering, database-operations, observability,
backup-recovery, production-verification, release-engineering.

### agents, 14 rôles

Hors catégories de skills : un agent n'a ni `SKILL.md` ni dossiers
`examples/` et `resources/`. Un agent est un rôle mince qui cite des skills et
transmet par le bloc de `engineering/agents/handoff-protocol.md`. Le détail
figure dans `delivery-system.md` section 8.

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

`tests/` contient trois scripts sans dépendance externe :

- `validate-structure.sh` vérifie la présence des fichiers et dossiers
  obligatoires de chaque skill, ainsi que le bloc de métadonnées. Pour
  les catégories d'ingénierie, il exige en plus une section `Protocol`
  numérotée et une section `Interfaces`.
- `validate-rules.sh` vérifie les interdits de la constitution sur tout le
  repository : emoji, tiret cadratin, guillemets droits hors blocs de code,
  exclamations multiples.
- `validate-orchestration.sh` vérifie la cohérence interne des trois
  catégories d'ingénierie et des agents : plans d'exécution, phases de
  livraison, portes obligatoires, références croisées, scénarios de routage,
  définitions d'agents.

## Extension

Ajouter un skill suppose : créer le dossier avec ses quatre éléments, déclarer
les métadonnées, renvoyer à la constitution sans la recopier, ajouter au moins
un exemple et une ressource, mettre à jour `documentation/skills-guide.md`,
puis exécuter les trois scripts de test.

Pour un skill d'une catégorie d'ingénierie, quatre exigences supplémentaires
figurent dans `engineering-system.md` section 9 et `delivery-system.md`
section 11 : titre de procédure `Protocol`, section `Interfaces`,
appartenance à au moins un plan d'exécution ou une phase de livraison, et mise
à jour de l'index de catégorie.

Ajouter un agent suppose : le fichier dans `engineering/agents/`, les huit
sections obligatoires, une entrée dans `engineering/agents/README.md`, et
l'ajout de son nom à la liste attendue de
`tests/validate-orchestration.sh`.
