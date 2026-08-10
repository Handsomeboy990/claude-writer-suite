# Claude Writer Suite

Bibliothèque de 62 skills professionnels pour un agent Claude, répartis en
deux systèmes indépendants.

- 42 skills d'écriture : romancier, scénariste, directeur littéraire, éditeur,
  critique, documentaliste, correcteur et bêta-lecteur, de la nouvelle à la
  saga.
- 20 skills d'ingénierie logicielle : exploration de code, architecture,
  frontend, backend, sécurité, tests, performance, revue, documentation et
  livraison.

## Objectif

Fournir des systèmes d'expertise, et non des prompts. Chaque skill contient
des protocoles numérotés, des critères de décision, des grilles d'évaluation
et des procédures de révision utilisables du premier chapitre au dernier.

La suite d'écriture couvre : romans, thrillers, science-fiction, fantasy,
horreur, mystère, roman policier, romance, fiction historique, poésie, analyse
littéraire, réécriture et correction.

Le système d'ingénierie couvre : exploration d'une base de code inconnue,
architecture, développement frontend et backend, validation des entrées, audit
de sécurité, débogage, tests, automatisation navigateur, performance, revue de
code, choix de dépendances, documentation, continuité de projet, Git et
préparation de mise en production. Il est agnostique de la pile technique et
lit le projet qu'on lui confie plutôt que d'en présupposer la forme.

## Architecture

```
claude-writer-suite/
├── CLAUDE.md          mémoire du projet, règles permanentes, règles Git
├── core/              14 skills fondamentaux d'écriture
├── genres/            15 spécialisations de genre
├── poetry/             5 skills de poésie
├── quality/            8 skills de contrôle qualité
├── dev-skills/        20 skills d'ingénierie logicielle
├── resources/         typographie, structures, lexiques, gabarits
├── examples/          projet de démonstration complet
├── documentation/     architecture, guide, règles, workflow, ingénierie
└── tests/             validation de structure, de règles et d'orchestration
```

Chaque skill est isolé dans son dossier :

```
skill-name/
├── SKILL.md
├── README.md
├── examples/
└── resources/
```

## Installation

Aucune dépendance. Le repository est un ensemble de fichiers Markdown.

```
git clone <url-du-depot> claude-writer-suite
cd claude-writer-suite
bash tests/validate-structure.sh
bash tests/validate-rules.sh
bash tests/validate-orchestration.sh
```

### Installer les skills pour un agent

```
bash install.sh           # copie les 62 skills dans ~/.claude/skills
bash install.sh --writing # les 42 skills d'écriture seulement
bash install.sh --dev     # les 20 skills d'ingénierie seulement
bash install.sh --zip     # construit aussi une archive par skill dans dist/
bash install.sh --remove  # désinstalle
```

Les options de portée se combinent avec `--zip` et `--remove`.

Le répertoire cible est configurable par la variable `CLAUDE_SKILLS_DIR`.
Les archives de `dist/` servent à un import manuel dans une interface qui
attend un fichier zip par skill.

Pour un usage sans installation, placer le repository dans le répertoire de
travail et faire lire `CLAUDE.md` en premier, puis la constitution du système
concerné : `core/writing-constitution/SKILL.md` pour l'écriture,
`dev-skills/engineering-core/SKILL.md` pour l'ingénierie.

## Utilisation

1. Remplir `resources/templates/demarrage-de-projet.md`.
2. Suivre `documentation/workflow.md`, phase par phase.
3. Ouvrir le skill correspondant à la tâche en cours. La table de choix par
   situation figure dans `documentation/skills-guide.md`.
4. Ne jamais livrer un texte sans le protocole
   `quality/self-critique-protocol`.

Exemple de chaîne minimale pour un chapitre :

```
chapter-architect -> scene-builder -> dialogue-master
    -> self-critique-protocol -> continuity-manager
```

Exemple de chaîne minimale pour un endpoint :

```
project-exploration -> backend-engineering -> input-validation
    -> security-audit -> testing-quality -> code-review-protocol
```

Un dossier de démonstration complet, de la bible au rapport de validation,
figure dans `examples/saga-les-cendres-de-kivu/`.

### Ingénierie logicielle

1. Charger `dev-skills/engineering-core`, qui porte les règles communes.
2. Laisser `dev-skills/engineering-orchestrator` classer la tâche et composer
   le plan minimal complet.
3. Ne rien supposer du projet : `dev-skills/project-exploration` établit les
   faits avant toute décision.
4. Ne jamais considérer un changement comme terminé avant
   `dev-skills/code-review-protocol`, avec un test exécuté et observé.

Le détail figure dans `documentation/engineering-system.md` et
`dev-skills/README.md`.

## Règles communes

Deux règles s'appliquent à tous les fichiers du repository, y compris aux
skills d'ingénierie : aucun emoji, aucun tiret cadratin.

Les autres, définies dans `core/writing-constitution/SKILL.md`, régissent les
textes de fiction et de poésie : dialogues conformes aux standards des
romans publiés en français, flashbacks en italique et clairement séparés de la
ligne principale, chronologie toujours compréhensible, titres de chapitres
travaillés, personnages cohérents, style naturel, refus des clichés, montrer
plutôt qu'expliquer, priorité à l'émotion incarnée, respect des cultures
représentées, aucune incohérence tolérée.

Chaque skill de production se termine par une auto-évaluation avec seuil de
livraison chiffré : onze axes pour l'écriture, des axes propres à chaque
skill d'ingénierie.

Les skills d'ingénierie ajoutent leurs propres règles non négociables, dans
`dev-skills/engineering-core/SKILL.md` : ne jamais deviner, lire avant
d'écrire, vérifier avant d'affirmer, traiter toute entrée externe comme
hostile, ne jamais versionner un secret.

## Contribution

Voir `CONTRIBUTING.md`. Toute contribution respecte la constitution, la
structure de skill imposée, et passe les deux scripts de `tests/`.

## Philosophie

- La contrainte produit le style. Les règles éliminent le bruit.
- Un texte se juge sur l'effet produit, jamais sur l'intention.
- La cohérence est une forme de respect du lecteur.
- Un skill doit rester utile au chapitre 3 comme au chapitre 90.
- Toute règle énoncée doit être vérifiable par une procédure explicite.
- La sévérité critique est un service rendu, pas une posture.

## Licence

MIT. Voir `LICENSE`.
