# Contribuer

## Avant toute modification

1. Lire `CLAUDE.md`.
2. Lire la constitution du système concerné :
   `core/writing-constitution/SKILL.md` pour un skill d'écriture,
   `dev-skills/engineering-core/SKILL.md` pour un skill d'ingénierie,
   `devops-skills/devops-core/SKILL.md` en plus pour un skill
   d'exploitation.
3. Vérifier la cohérence avec `documentation/architecture.md`, avec
   `documentation/engineering-system.md` pour `dev-skills`, et avec
   `documentation/delivery-system.md` pour `delivery-skills`,
   `devops-skills` et `agents`.

## Ajouter un skill

1. Créer le dossier dans la catégorie appropriée : `core`, `genres`,
   `poetry`, `quality`, `dev-skills`, `delivery-skills` ou `devops-skills`.
2. Créer les quatre éléments obligatoires : `SKILL.md`, `README.md`,
   `examples/`, `resources/`. Les deux dossiers ne peuvent pas rester vides.
3. Ouvrir `SKILL.md` par le bloc de métadonnées :

```yaml
---
name: nom-du-skill
description: Ce que fait le skill, puis quand l'utiliser, avec les termes qui
  doivent le déclencher. Quarante caractères minimum.
license: MIT
metadata:
  category: core | genres | poetry | quality | dev-skills | delivery-skills | devops-skills
  version: 1.0.0
  depends_on: [writing-constitution]
  outputs: [artefacts produits]
---
```

`name` et `description` restent au premier niveau : ils conditionnent la
découverte du skill par un agent. Tout le reste passe sous `metadata`.

4. Structurer le contenu : rôle, entrées, procédure numérotée, livrables,
   erreurs fréquentes, section Auto-critique, interfaces.
5. Renvoyer à la constitution, ne jamais la recopier.
6. Ajouter au moins un exemple appliqué et une grille ou checklist.
7. Mettre à jour `documentation/skills-guide.md` et
   `documentation/architecture.md`.
8. Exécuter les trois scripts de validation.

Un skill d'une catégorie d'ingénierie ajoute quatre exigences propres :

- la procédure porte le titre `Protocol` et une section `Interfaces` est
  obligatoire, toutes deux vérifiées par `tests/validate-structure.sh` ;
- le contenu est rédigé en anglais, pour la raison exposée dans
  `documentation/engineering-system.md` section 2 ;
- le skill figure dans au moins un plan de
  `dev-skills/engineering-orchestrator/resources/execution-plans.md` ou dans
  une phase de
  `delivery-skills/delivery-orchestrator/resources/delivery-phases.md`, faute
  de quoi `tests/validate-orchestration.sh` le signale comme orphelin ;
- il est ajouté à l'index de sa catégorie et à la documentation
  correspondante.

## Ajouter un agent

1. Créer le fichier dans `agents/`, nommé d'après l'agent.
2. Ouvrir par un bloc de métadonnées avec `name` identique au nom du fichier
   et une `description` d'au moins quarante caractères.
3. Inclure les huit sections obligatoires : `Role`, `Mission`,
   `Responsibilities`, `Inputs`, `Outputs`, `Boundaries`, `Verification`,
   `Handoff`. Une section `Skills` cite les skills utilisés.
4. Ne jamais recopier le contenu d'un skill : le citer.
5. Ajouter une ligne dans `agents/README.md`.
6. Ajouter le nom à la liste attendue de `tests/validate-orchestration.sh`.
7. Exécuter les trois scripts de validation.

## Exigences de contenu

- Rédaction en français pour les skills d'écriture, en anglais pour
  `dev-skills`, `delivery-skills`, `devops-skills` et `agents`. Noms de
  fichiers et de dossiers en anglais, en kebab-case partout.
- Aucun emoji, aucun tiret cadratin, y compris dans les tableaux.
- Tout protocole est numéroté et exécutable, sans formulation vague.
- Toute règle énoncée est vérifiable par une procédure ou une grille.
- Les exemples sont concrets et commentés : montrer avant et après.

## Tests

```
bash tests/validate-structure.sh
bash tests/validate-rules.sh
bash tests/validate-orchestration.sh
```

Les trois scripts doivent passer sans erreur avant tout commit.

## Git

Identité obligatoire :

```
git config user.name  "Handsomeboy990"
git config user.email "lauretchacha@gmail.com"
```

Commits en anglais, courts, atomiques, décrivant uniquement le changement
réalisé. Préfixes admis : `feat:`, `docs:`, `fix:`, `chore:`, `refactor:`,
`test:`.

```
feat: add thriller writing skill
docs: update architecture guide
fix: improve dialogue validation rules
```

Interdits absolus dans les messages de commit et les métadonnées :
`Co-authored-by`, mentions d'un générateur automatique, mentions d'une
assistance par intelligence artificielle. L'auteur visible reste
`Handsomeboy990 <lauretchacha@gmail.com>`.

Ne jamais versionner : `.env` et ses variantes, clés privées, certificats,
informations d'identification, configuration locale d'un agent. Lire le diff
indexé en entier avant chaque commit. Un secret déjà poussé se révoque, il ne
se supprime pas.

## Modifier une constitution

Toute modification de `core/writing-constitution/SKILL.md` impose :

1. la vérification des skills qui s'y réfèrent ;
2. la mise à jour de `documentation/writing-rules.md` ;
3. la mise à jour de la grille de conformité ;
4. une entrée dans `CHANGELOG.md`.

Toute modification de `dev-skills/engineering-core/SKILL.md` impose :

1. la vérification des quarante et un skills qui en héritent ;
2. la mise à jour de `documentation/engineering-system.md` ;
3. l'exécution de `tests/validate-orchestration.sh` ;
4. une entrée dans `CHANGELOG.md`.

Toute modification de `devops-skills/devops-core/SKILL.md` impose :

1. la vérification des dix skills d'exploitation qui en héritent ;
2. la mise à jour de `documentation/delivery-system.md` ;
3. l'exécution de `tests/validate-orchestration.sh` ;
4. une entrée dans `CHANGELOG.md`.
