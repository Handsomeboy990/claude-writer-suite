# Claude Writer Suite

Bibliothèque de 42 skills d'écriture professionnelle pour un agent Claude.
Elle permet à un agent d'intervenir comme écrivain de roman, scénariste,
directeur littéraire, éditeur, critique, documentaliste, correcteur et
bêta-lecteur, sur des projets allant de la nouvelle à la saga.

## Objectif

Fournir des systèmes d'expertise, et non des prompts. Chaque skill contient
des protocoles numérotés, des critères de décision, des grilles d'évaluation
et des procédures de révision utilisables du premier chapitre au dernier.

La suite couvre : romans, thrillers, science-fiction, fantasy, horreur,
mystère, roman policier, romance, fiction historique, poésie, analyse
littéraire, réécriture et correction.

## Architecture

```
claude-writer-suite/
├── CLAUDE.md          mémoire du projet, règles permanentes, règles Git
├── core/              14 skills fondamentaux
├── genres/            15 spécialisations de genre
├── poetry/             5 skills de poésie
├── quality/            8 skills de contrôle qualité
├── resources/         typographie, structures, lexiques, gabarits
├── examples/          projet de démonstration complet
├── documentation/     architecture, guide, règles, workflow
└── tests/             validation de structure et de conformité
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
```

Pour un usage avec un agent, placer le repository dans le répertoire de
travail et faire lire `CLAUDE.md` en premier, puis
`core/writing-constitution/SKILL.md`.

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

Un dossier de démonstration complet, de la bible au rapport de validation,
figure dans `examples/saga-les-cendres-de-kivu/`.

## Règles communes

Non négociables, définies dans `core/writing-constitution/SKILL.md` :

aucun emoji, aucun tiret cadratin, dialogues conformes aux standards des
romans publiés en français, flashbacks en italique et clairement séparés de la
ligne principale, chronologie toujours compréhensible, titres de chapitres
travaillés, personnages cohérents, style naturel, refus des clichés, montrer
plutôt qu'expliquer, priorité à l'émotion incarnée, respect des cultures
représentées, aucune incohérence tolérée.

Chaque skill de production se termine par une auto-évaluation en onze axes,
avec seuil de livraison chiffré.

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
