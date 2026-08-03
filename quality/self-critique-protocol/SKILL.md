---
name: self-critique-protocol
category: quality
version: 1.0.0
depends_on: [writing-constitution]
outputs: [grille-notee, liste-de-corrections, version-revisee]
---

# Self Critique Protocol

Protocole d'auto-évaluation obligatoire. Aucun texte produit par un skill de
la suite n'est livré sans être passé par ce protocole. Il ne s'agit pas d'un
avis, mais d'une procédure reproductible.

## 1. Règle absolue

Générer, évaluer, corriger, réévaluer. Un texte non réévalué après correction
n'est pas terminé. Le protocole s'exécute au minimum une fois, et se répète
tant que le seuil n'est pas atteint, dans la limite de trois cycles. Au
troisième échec, le texte est réécrit depuis la fiche de scène, non retouché.

## 2. Les onze axes

Chaque axe est noté de 0 à 5. La note doit être justifiée par une preuve
prise dans le texte, citée. Une note sans preuve est nulle et vaut 0.

### 1. Qualité narrative
La scène raconte-t-elle quelque chose, ou décrit-elle seulement ? Y a-t-il un
mouvement, une progression, une transformation ?

### 2. Cohérence
Contradictions internes, avec la bible, avec les chapitres antérieurs, avec
le registre de continuité.

### 3. Rythme
Alternance des longueurs de phrase et de paragraphe, adéquation entre densité
et tension, présence de temps morts non voulus.

### 4. Personnages
Chacun veut-il quelque chose ? Agit-il selon sa fiche ? A-t-il une voix
propre ? A-t-il le droit d'exister hors de l'intrigue ?

### 5. Dialogues
Conformité typographique, sous-texte, différenciation, absence d'exposition,
économie des incises.

### 6. Émotion
Les quatre appuis de la constitution sont-ils présents : enjeu, résistance,
manifestation physique précise, conséquence irréversible.

### 7. Originalité
Le traitement est-il celui que tout le monde aurait écrit ? Y a-t-il au moins
un choix que personne n'attendait ?

### 8. Crédibilité
Le lecteur peut-il croire aux faits, aux réactions, aux durées, aux
compétences affichées ?

### 9. Répétitions
Mots, images, structures de phrase, gestes récurrents sur une fenêtre de trois
cents mots.

### 10. Clichés
Formules usées, situations types, personnages types non subvertis.

### 11. Logique
Enchaînement causal, décisions plausibles, absence de facilité et de hasard
favorable.

## 3. Barème

| Note | Signification |
|---|---|
| 0 | absent ou contraire à la constitution |
| 1 | gravement défaillant |
| 2 | insuffisant, correction obligatoire |
| 3 | acceptable, publiable sans fierté |
| 4 | bon, conforme au niveau professionnel |
| 5 | remarquable, tient seul hors contexte |

Seuil de livraison : aucun axe inférieur à 3, moyenne supérieure ou égale à
3,8. Pour un chapitre de bascule ou d'ouverture, seuil relevé à 4,2.

## 4. Procédure

### Passe 1 : lecture froide
Lire le texte sans intention de correction, en notant uniquement les endroits
où l'attention décroche. Marquer d'un signe, ne rien corriger.

### Passe 2 : notation
Remplir la grille, un axe après l'autre, en citant une preuve par note.
Interdiction de noter deux axes simultanément : chaque axe est une lecture.

### Passe 3 : diagnostic
Pour chaque axe sous 4, écrire la cause, pas le symptôme. Exemple : `le
dialogue est plat` est un symptôme, `les deux personnages veulent la même
chose` est une cause.

### Passe 4 : correction
Corriger par ordre décroissant de gravité. Une correction de cause vaut mieux
que dix corrections de surface. Ne jamais corriger un axe en dégradant un
autre : vérifier après chaque correction majeure.

### Passe 5 : réévaluation
Renoter les axes touchés. Si le seuil est atteint, livrer avec la grille. Si
un axe reste sous 3 après trois cycles, réécrire.

## 5. Questions de déblocage

Quand un axe stagne, appliquer la question correspondante :

| Axe | Question de déblocage |
|---|---|
| Narrative | Que perd le personnage dans cette scène ? |
| Cohérence | Qui sait quoi, et depuis quand ? |
| Rythme | Quel paragraphe puis-je supprimer sans rien perdre ? |
| Personnages | Que veut celui qui parle le moins ? |
| Dialogues | Que refusent-ils de dire ? |
| Émotion | Quel geste remplacerait l'émotion nommée ? |
| Originalité | Quelle est la deuxième idée qui m'est venue ? |
| Crédibilité | Un praticien rirait-il en lisant ceci ? |
| Répétitions | Quel mot revient trois fois en une page ? |
| Clichés | Ai-je déjà lu cette phrase ailleurs ? |
| Logique | Pourquoi ne fait-il pas la chose la plus simple ? |

## 6. Format de sortie

Le protocole produit systématiquement trois éléments :

1. la grille notée avec preuves ;
2. la liste ordonnée des corrections effectuées ;
3. la version révisée.

Aucune livraison partielle.

## 7. Anti-complaisance

Trois règles pour éviter l'auto-validation :

- Interdiction de noter 5 plus d'une fois par grille sans preuve exceptionnelle.
- Toute grille dont la moyenne dépasse 4,5 dès le premier cycle est suspecte
  et doit être recontrôlée par `quality/literary-critic`.
- Le protocole cherche ce qui ne va pas. Il ne rédige pas d'éloge.

## 8. Interfaces

- Amont : tous les skills de production.
- Aval : `story-doctor`, `literary-editor`, `literary-critic`.
