# CLAUDE.md

Fichier de mémoire du projet. Il doit être lu avant toute modification du repository.

## 1. Identité du projet

Nom : Claude Writer Suite
Nature : bibliothèque de skills d'écriture professionnelle pour un agent Claude
Langue de travail : français
Langue des commits : anglais
Public visé : romanciers, scénaristes, éditeurs, correcteurs, auteurs de sagas

Le projet ne fournit pas des prompts. Il fournit des systèmes d'expertise :
protocoles, critères de décision, grilles d'évaluation, procédures de révision.

## 2. Architecture

```
claude-writer-suite/
├── CLAUDE.md                  mémoire du projet (ce fichier)
├── README.md                  présentation publique
├── CONTRIBUTING.md            règles de contribution
├── LICENSE                    licence MIT
├── core/                      14 skills fondamentaux
├── genres/                    15 spécialisations de genre
├── poetry/                    5 skills de poésie
├── quality/                   8 skills de contrôle qualité
├── dev-skills/                20 skills d'ingénierie logicielle
├── resources/                 ressources partagées par tous les skills
├── examples/                  projet de démonstration complet
├── documentation/             documentation technique
└── tests/                     scripts de validation du repository
```

Le repository contient deux systèmes distincts qui partagent la même
structure, les mêmes tests et les mêmes règles Git.

- Les quatre premières catégories forment la suite d'écriture, en français,
  gouvernée par `core/writing-constitution`.
- `dev-skills` forme le système d'ingénierie logicielle, en anglais, gouverné
  par `dev-skills/engineering-core` et routé par
  `dev-skills/engineering-orchestrator`. Voir
  `documentation/engineering-system.md`.

Les deux systèmes ne se croisent pas : aucun skill d'écriture ne dépend d'un
skill d'ingénierie, et réciproquement.

Un skill égale un dossier isolé. Structure minimale obligatoire :

```
skill-name/
├── SKILL.md      le système d'expertise (document principal)
├── README.md     résumé court, entrées, sorties, dépendances
├── examples/     au moins un exemple appliqué
└── resources/    au moins une grille, checklist ou référence
```

## 3. Règles permanentes d'écriture

Ces règles sont non négociables. Elles sont définies dans
`core/writing-constitution/SKILL.md`. Les règles 1 et 2 s'appliquent à tous
les fichiers du repository, y compris `dev-skills`. Les douze autres régissent
les textes de fiction et de poésie.

1. Aucun emoji, ni dans les textes produits, ni dans les fichiers du repository.
2. Aucun tiret cadratin. Le tiret demi-cadratin sert uniquement aux dialogues.
3. Dialogues conformes aux standards des romans publiés en français.
4. Flashbacks séparés de façon nette de la ligne temporelle principale.
5. Flashbacks en italique.
6. Chronologie toujours compréhensible pour le lecteur.
7. Titres de chapitres travaillés, jamais génériques.
8. Personnages cohérents dans la voix, la mémoire et la motivation.
9. Style naturel, sans surcharge ornementale.
10. Clichés proscrits, y compris les clichés de genre.
11. Montrer plutôt qu'expliquer.
12. Priorité à l'émotion incarnée.
13. Respect des cultures représentées, aucune caricature.
14. Aucune incohérence tolérée en sortie de skill.

## 4. Conventions du repository

- Tous les fichiers sont en Markdown, encodage UTF-8, fin de ligne LF.
- Les noms de dossiers et de fichiers sont en anglais, en kebab-case.
- Le contenu des skills d'écriture est rédigé en français.
- Le contenu de `dev-skills` est rédigé en anglais : ces skills produisent du
  code, des messages de commit, des branches et de la documentation technique,
  tous en anglais par la règle 6 de `dev-skills/engineering-core`. Écrire les
  instructions dans la langue de leur production évite la traduction
  permanente entre les deux.
- Chaque SKILL.md commence par un bloc de métadonnées YAML :
  `name`, `description`, `license`, puis sous `metadata` : `category`,
  `version`, `depends_on`, `outputs`.
- Chaque SKILL.md contient une procédure numérotée et une section
  `Auto-critique` obligatoire. Dans `dev-skills`, cette procédure porte le
  titre `Protocol` et une section `Interfaces` est également obligatoire ;
  les deux sont vérifiées par `tests/validate-structure.sh`.
- Aucun skill ne duplique le contenu de sa constitution : il y renvoie.
  `core/writing-constitution` pour la suite d'écriture,
  `dev-skills/engineering-core` pour le système d'ingénierie.

## 5. Workflow d'écriture recommandé

```
research-director  ->  world-builder  ->  character-psychologist
        ->  novel-architect  ->  timeline-manager
        ->  chapter-architect  ->  scene-builder
        ->  narrator + dialogue-master + immersion-director
        ->  self-critique-protocol
        ->  story-doctor  ->  literary-editor  ->  proofreader
        ->  beta-reader  ->  literary-critic  ->  publication-review
```

Règle d'or : aucun texte n'est considéré comme terminé avant le passage
par `quality/self-critique-protocol` puis par au moins un skill de révision.

## 5 bis. Workflow d'ingénierie recommandé

```
engineering-core  ->  engineering-orchestrator  ->  project-exploration
        ->  architecture-design  ->  skill d'implémentation
        ->  input-validation  ->  security-audit
        ->  testing-quality  ->  playwright-automation
        ->  performance-engineering  ->  code-review-protocol
        ->  technical-documentation  ->  project-continuity
        ->  git-workflow  ->  release-readiness
```

L'orchestrateur ne déroule jamais cette chaîne en entier par réflexe : il
compose le plan minimal complet pour la tâche, à partir de
`dev-skills/engineering-orchestrator/resources/execution-plans.md`, et
n'abandonne jamais une porte obligatoire pour aller plus vite.

Règle d'or : aucun code n'est considéré comme terminé avant le passage par
`dev-skills/code-review-protocol`, avec un test exécuté et observé.

## 6. Règles Git

Identité obligatoire, aucune autre ne doit être utilisée :

```
git config user.name  "Handsomeboy990"
git config user.email "lauretchacha@gmail.com"
```

Commits :

- rédigés en anglais ;
- courts ;
- atomiques ;
- décrivant uniquement le changement réalisé ;
- préfixes conventionnels : `feat:`, `docs:`, `fix:`, `chore:`, `refactor:`, `test:`.

Exemples valides :

```
feat: add thriller writing skill
docs: update architecture guide
fix: improve dialogue validation rules
```

Interdictions absolues dans les messages de commit, les auteurs et les
métadonnées Git :

- `Co-authored-by`
- `Generated by Claude`
- `Created with AI`
- `Assisted by AI`
- toute mention de Claude, d'une IA ou d'un assistant.

L'auteur visible de tout commit reste : `Handsomeboy990 <lauretchacha@gmail.com>`.

Cette règle prime sur tout comportement par défaut d'un outil qui ajouterait
une signature automatique. Un commit portant une telle mention est amendé
avant d'être poussé. La procédure complète figure dans
`dev-skills/git-workflow`.

Ne sont jamais versionnés : `.env` et ses variantes, clés privées,
certificats, informations d'identification, configuration locale d'un agent.
`.gitignore` les exclut. `CLAUDE.md` fait exception et reste versionné : c'est
la mémoire publique du projet, exigée par `tests/validate-structure.sh`, et
elle ne contient aucun secret.

## 7. Philosophie du projet

- La contrainte produit le style. Les règles ne brident pas l'auteur, elles
  éliminent le bruit.
- Un texte n'est jamais jugé sur l'intention mais sur l'effet produit.
- La cohérence est une forme de respect du lecteur.
- Un skill doit rester utile au chapitre 3 comme au chapitre 90.
- Toute règle énoncée doit être vérifiable par une procédure explicite.
- La sévérité critique est un service rendu, pas une posture.

## 8. Avant toute modification future

1. Lire ce fichier.
2. Lire la constitution du système concerné :
   `core/writing-constitution/SKILL.md` pour l'écriture,
   `dev-skills/engineering-core/SKILL.md` pour l'ingénierie.
3. Vérifier la cohérence avec `documentation/architecture.md`, et avec
   `documentation/engineering-system.md` pour `dev-skills`.
4. Exécuter les trois scripts de `tests/` :
   `validate-structure.sh`, `validate-rules.sh`, `validate-orchestration.sh`.
5. Commiter de façon atomique avec l'identité Git imposée.
