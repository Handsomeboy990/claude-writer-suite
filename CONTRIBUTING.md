# Contribuer

## Avant toute modification

1. Lire `CLAUDE.md`.
2. Lire `core/writing-constitution/SKILL.md`.
3. Vérifier la cohérence avec `documentation/architecture.md`.

## Ajouter un skill

1. Créer le dossier dans la catégorie appropriée : `core`, `genres`,
   `poetry` ou `quality`.
2. Créer les quatre éléments obligatoires : `SKILL.md`, `README.md`,
   `examples/`, `resources/`. Les deux dossiers ne peuvent pas rester vides.
3. Ouvrir `SKILL.md` par le bloc de métadonnées :

```yaml
---
name: nom-du-skill
category: core | genres | poetry | quality
version: 1.0.0
depends_on: [writing-constitution]
outputs: [artefacts produits]
---
```

4. Structurer le contenu : rôle, entrées, protocole numéroté, livrables,
   erreurs fréquentes, section Auto-critique, interfaces.
5. Renvoyer à la constitution, ne jamais la recopier.
6. Ajouter au moins un exemple appliqué et une grille ou checklist.
7. Mettre à jour `documentation/skills-guide.md` et
   `documentation/architecture.md`.
8. Exécuter les deux scripts de validation.

## Exigences de contenu

- Rédaction en français, noms de fichiers et de dossiers en anglais, en
  kebab-case.
- Aucun emoji, aucun tiret cadratin, y compris dans les tableaux.
- Tout protocole est numéroté et exécutable, sans formulation vague.
- Toute règle énoncée est vérifiable par une procédure ou une grille.
- Les exemples sont concrets et commentés : montrer avant et après.

## Tests

```
bash tests/validate-structure.sh
bash tests/validate-rules.sh
```

Les deux scripts doivent passer sans erreur avant tout commit.

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

## Modifier la constitution

Toute modification de `core/writing-constitution/SKILL.md` impose :

1. la vérification des skills qui s'y réfèrent ;
2. la mise à jour de `documentation/writing-rules.md` ;
3. la mise à jour de la grille de conformité ;
4. une entrée dans `CHANGELOG.md`.
