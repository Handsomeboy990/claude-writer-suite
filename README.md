# Claude Writer Suite

Deux systèmes d'expertise pour un agent Claude, dans un seul repository :
**écrire** et **construire des logiciels**.

83 skills et 14 agents. Pas des prompts : des protocoles numérotés, des
critères de décision, des grilles d'évaluation et des procédures de révision.

```
claude-writer-suite/
├── writing/          42 skills d'écriture professionnelle, en français
├── engineering/      41 skills d'ingénierie et 14 agents, en anglais
├── documentation/    documentation technique des deux systèmes
└── tests/            trois scripts de validation
```

Les deux arbres sont indépendants. Aucun skill de l'un ne dépend d'un skill de
l'autre. Ils partagent la structure de skill, les tests et les règles Git,
rien d'autre.

## writing

Bibliothèque d'écriture professionnelle. L'agent intervient comme romancier,
scénariste, directeur littéraire, éditeur, critique, documentaliste,
correcteur et bêta-lecteur, de la nouvelle à la saga.

| Catégorie | Skills | Objet |
|---|---|---|
| [core](writing/core/) | 14 | fondations et production |
| [genres](writing/genres/) | 15 | thriller, mystère, fantasy, SF, romance, historique |
| [poetry](writing/poetry/) | 5 | prosodie française et quatre formes |
| [quality](writing/quality/) | 8 | diagnostic, réécriture, correction, validation |

Plus [resources/](writing/resources/), typographie et lexiques partagés, et
[examples/](writing/examples/), un projet de démonstration complet.

Index : [writing/README.md](writing/README.md).

## engineering

Système d'ingénierie logicielle et de livraison de projet. L'agent prend un
cahier des charges et livre un système implémenté, testé, documenté, déployé
et vérifié en production.

| Catégorie | Skills | Question à laquelle elle répond |
|---|---|---|
| [dev-skills](engineering/dev-skills/) | 20 | comment une modification est faite correctement |
| [delivery-skills](engineering/delivery-skills/) | 10 | quoi construire, dans quel ordre, avec quelle approbation |
| [devops-skills](engineering/devops-skills/) | 11 | comment le système tourne, se déploie et se restaure |
| [agents](engineering/agents/) | 14 | qui possède quoi, et ce qui est transmis |

Agnostique de la pile technique et de la plateforme : le système lit le projet
qu'on lui confie plutôt que d'en présupposer la forme.

Index : [engineering/README.md](engineering/README.md).

## Installation

Aucune dépendance. Le repository est un ensemble de fichiers Markdown.

```
git clone <url-du-depot> claude-writer-suite
cd claude-writer-suite
bash tests/validate-structure.sh
bash tests/validate-rules.sh
bash tests/validate-orchestration.sh
```

Puis, pour installer dans le répertoire personnel de l'agent :

```
bash install.sh              83 skills et 14 agents
bash install.sh --writing    les 42 skills d'écriture seulement
bash install.sh --dev        les 41 skills d'ingénierie seulement
bash install.sh --agents     les 14 agents seulement
bash install.sh --no-agents  les skills sans les agents
bash install.sh --zip        construit aussi une archive par skill dans dist/
bash install.sh --remove     désinstalle
```

Les options de portée se combinent avec `--zip` et `--remove`. Les skills vont
dans `~/.claude/skills`, les agents dans `~/.claude/agents` ; les deux cibles
sont configurables par `CLAUDE_SKILLS_DIR` et `CLAUDE_AGENTS_DIR`.

Pour un usage sans installation, placer le repository dans le répertoire de
travail et faire lire `CLAUDE.md` en premier, puis la constitution du système
concerné.

## Démarrer

### Écrire

1. Remplir `writing/resources/templates/demarrage-de-projet.md`.
2. Charger `writing/core/writing-constitution`, qui porte les règles communes.
3. Suivre `documentation/workflow.md`, phase par phase.
4. Ne jamais livrer un texte sans `writing/quality/self-critique-protocol`.

```
chapter-architect -> scene-builder -> dialogue-master
    -> self-critique-protocol -> continuity-manager
```

### Construire

1. Charger `engineering/dev-skills/engineering-core`, qui porte les règles
   communes.
2. Laisser `engineering/dev-skills/engineering-orchestrator` classer la tâche
   et composer le plan minimal complet.
3. Ne rien supposer du projet : `project-exploration` établit les faits avant
   toute décision.
4. Ne jamais considérer un changement comme terminé avant
   `code-review-protocol`, avec un test exécuté et observé.

```
project-exploration -> backend-engineering -> input-validation
    -> security-audit -> testing-quality -> code-review-protocol
```

### Livrer un projet complet

Quand l'entrée est une spécification plutôt qu'une tâche,
`engineering/delivery-skills/delivery-orchestrator` prend la main sur quatorze
phases, avec quatre portes d'approbation.

```
requirements-analysis -> clarification-gate -> technology-selection
    -> architecture-proposal -> validation-gate -> delivery-planning
```

Deux règles structurantes : aucun code de production avant la porte de
validation, échafaudage compris ; aucune demande d'autorisation après, pour le
travail inclus dans le périmètre approuvé.

## Règles communes aux deux arbres

Deux interdits s'appliquent à tous les fichiers du repository : **aucun
emoji**, **aucun tiret cadratin**. Ils sont vérifiés par
`tests/validate-rules.sh`.

Le reste diffère par arbre :

- `writing/core/writing-constitution` : dialogues aux normes françaises,
  flashbacks en italique, chronologie compréhensible, titres travaillés,
  personnages cohérents, refus des clichés, montrer plutôt qu'expliquer,
  respect des cultures représentées.
- `engineering/dev-skills/engineering-core` : ne jamais deviner, lire avant
  d'écrire, vérifier avant d'affirmer, traiter toute entrée externe comme
  hostile, ne jamais versionner un secret, finir le travail.
- `engineering/devops-skills/devops-core` : ne rien coder en dur qui varie
  selon l'environnement, refuser de démarrer sans une variable requise,
  classer le rayon d'impact avant toute opération, vérifier la cible avant
  toute action destructrice.

Chaque skill se termine par une auto-évaluation avec seuil de livraison
chiffré.

## Documentation

| Fichier | Contenu |
|---|---|
| [CLAUDE.md](CLAUDE.md) | mémoire du projet, conventions, règles Git |
| [documentation/architecture.md](documentation/architecture.md) | organisation, isolation des skills, métadonnées |
| [documentation/skills-guide.md](documentation/skills-guide.md) | répertoire des 83 skills, table de choix |
| [documentation/writing-rules.md](documentation/writing-rules.md) | règles d'écriture, version opérationnelle |
| [documentation/workflow.md](documentation/workflow.md) | workflow d'écriture en onze phases |
| [documentation/engineering-system.md](documentation/engineering-system.md) | la couche dev-skills en détail |
| [documentation/delivery-system.md](documentation/delivery-system.md) | livraison, exploitation et agents |
| [CONTINUITY.md](CONTINUITY.md) | état de reprise du repository |
| [CHANGELOG.md](CHANGELOG.md) | historique des versions |

## Validation

```
bash tests/validate-structure.sh      structure et métadonnées des 83 skills
bash tests/validate-rules.sh          emoji, tiret cadratin, typographie
bash tests/validate-orchestration.sh  plans, phases, agents, références
```

Les trois doivent passer sans erreur avant tout commit. Le détail figure dans
[tests/README.md](tests/README.md).

## Contribution

Voir [CONTRIBUTING.md](CONTRIBUTING.md). Toute contribution respecte la
constitution de son arbre, la structure de skill imposée, et passe les trois
scripts de `tests/`.

## Philosophie

- La contrainte produit le style. Les règles éliminent le bruit.
- Un texte se juge sur l'effet produit, jamais sur l'intention.
- Un système se juge sur ce qui a été exécuté, jamais sur ce qui a été prévu.
- La cohérence est une forme de respect du lecteur, et de l'ingénieur suivant.
- Un skill doit rester utile au chapitre 3 comme au chapitre 90, au premier
  commit comme au centième.
- Toute règle énoncée doit être vérifiable par une procédure explicite.
- La sévérité critique est un service rendu, pas une posture.

## Licence

MIT. Voir [LICENSE](LICENSE).
