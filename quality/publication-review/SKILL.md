---
name: publication-review
category: quality
version: 1.0.0
depends_on: [writing-constitution, continuity-manager, proofreader]
outputs: [rapport-de-validation, decision-de-publication]
---

# Publication Review

Validation finale avant publication. Ce skill ne juge pas la qualité
littéraire, déjà traitée par `literary-critic` : il vérifie qu'aucun
défaut objectif ne subsiste et prononce une décision.

## 1. Position dans le processus

Ce skill intervient en dernier, après `literary-editor`, `proofreader` et
`continuity-manager`. Il ne modifie rien. Il valide, ou il renvoie avec une
liste fermée de corrections.

## 2. Les sept contrôles

### Contrôle 1 : conformité constitution
Grille complète de `core/writing-constitution/resources/grille-de-conformite.md`.
Un seul manquement bloque.

### Contrôle 2 : continuité
Rapport d'audit en huit passages fourni par `continuity-manager`, sans
incohérence bloquante ni majeure.

### Contrôle 3 : promesses
Toutes les promesses ouvertes sont tenues, ou volontairement reportées à un
tome suivant et consignées comme telles.

### Contrôle 4 : documentation
Toute affirmation de niveau 3 est adossée à une fiche source. Aucun
anachronisme non assumé.

### Contrôle 5 : représentation
Aucune culture, condition ou communauté traitée en décor, en caricature ou en
raccourci. Contrôle croisé avec le profil de lecture concerné de
`beta-reader`.

### Contrôle 6 : correction
Relevé de `proofreader` clos, cas douteux tranchés par l'auteur.

### Contrôle 7 : appareil du livre
Titre, titres de chapitre, table des matières, exergue, dédicace, mentions
légales, remerciements, cohérence des noms dans le paratexte.

## 3. Contrôles techniques de fichier

- Encodage UTF-8.
- Aucun caractère de contrôle résiduel.
- Aucun double espace, aucune espace en fin de ligne.
- Sauts de page conformes, un chapitre par page impaire si l'édition l'exige.
- Numérotation continue, aucun chapitre manquant ni dupliqué.
- Styles homogènes : corps, dialogue, italique, exergue.

## 4. Décision

| Décision | Condition |
|---|---|
| Validé | les sept contrôles sont passés |
| Validé sous réserve | uniquement des points mineurs, listés, à corriger avant tirage |
| Renvoyé | au moins un contrôle bloquant échoué |
| Suspendu | doute documentaire ou de représentation nécessitant une expertise externe |

La décision est écrite, datée, et accompagnée de la liste exhaustive des
points restants. Aucune décision orale, aucune validation implicite.

## 5. Dossier de publication

Le dossier livré contient :

1. le manuscrit final ;
2. le rapport de validation ;
3. le registre de continuité clos ;
4. le dossier documentaire ;
5. les grilles d'auto-critique des chapitres de bascule ;
6. le journal des coupes et le journal de réécriture ;
7. la liste des écarts assumés.

Ce dossier constitue la mémoire du livre. Il sert au tome suivant, à
l'adaptation, et à toute contestation éditoriale.

## 6. Auto-critique

Axes notés de 0 à 5 : exhaustivité des contrôles, netteté de la décision,
exactitude de la liste de points restants, complétude du dossier, absence de
validation complaisante.

Seuil : aucun axe sous 4.

## 7. Interfaces

- Amont : `literary-editor`, `proofreader`, `continuity-manager`,
  `literary-critic`, `beta-reader`.
- Aval : publication.
