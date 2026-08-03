---
name: haiku
category: poetry
version: 1.0.0
depends_on: [writing-constitution, poet]
outputs: [haikus, serie-saisonniere]
---

# Haiku

Forme brève d'origine japonaise. En français, elle ne se réduit pas à un
compte de syllabes : elle repose sur une perception, une saison et une
coupure.

## 1. Les trois éléments

1. Le compte : traditionnellement cinq, sept, cinq. En français, la brièveté
   compte plus que l'exactitude arithmétique. Un haiku de treize à dix-sept
   syllabes est recevable si le déséquilibre est maîtrisé.
2. Le mot de saison : un terme qui situe le poème dans un moment de l'année,
   par un phénomène concret et non par le nom de la saison.
3. La césure : une rupture entre deux images, qui produit un écart. C'est
   l'élément essentiel et le plus souvent manqué.

## 2. Ce qu'un haiku n'est pas

- Ce n'est pas un aphorisme. Aucune leçon, aucune morale.
- Ce n'est pas une métaphore. Les deux images sont juxtaposées, pas
  substituées.
- Ce n'est pas un sentiment exprimé. L'émotion naît de l'écart entre les
  images, jamais de sa formulation.
- Ce n'est pas une phrase coupée en trois lignes.

## 3. Technique de la coupure

Structure la plus fiable : deux vers pour une image, un vers pour l'autre.
La coupure se place entre les deux, sans ponctuation lourde.

Types d'écart efficaces :

| Écart | Exemple de principe |
|---|---|
| Échelle | un très grand et un très petit |
| Temps | ce qui dure et ce qui passe |
| Sensoriel | un son et une chose vue |
| Humain et non humain | un geste et un phénomène naturel |
| Présence et absence | ce qui reste après quelqu'un |

## 4. Règles d'écriture

- Présent, ou absence de verbe.
- Aucun adjectif évaluatif : beau, triste, magnifique.
- Aucun `je` explicite dans la plupart des cas. La subjectivité passe par le
  choix du détail.
- Aucune comparaison introduite par `comme`.
- Un seul concret par ligne.
- Pas de titre.

## 5. Adaptation au contexte francophone

Le mot de saison japonais renvoie à un almanach codifié. En français, il faut
choisir des marqueurs locaux vérifiables : une récolte, un vent nommé, un
oiseau migrateur, une pratique saisonnière. Un haiku écrit sous les tropiques
n'a pas quatre saisons : il a des saisons sèches et des saisons de pluies, et
c'est cela qu'il doit inscrire.

## 6. Séries

Un haiku isolé est fragile. Composer par séries de cinq à douze, reliées par
un lieu ou une saison, produit un ensemble plus solide et permet la
progression.

## 7. Auto-critique

Axes notés de 0 à 5 : présence d'un vrai écart, justesse du marqueur
saisonnier, concrétude, absence de sentiment formulé, brièveté, oralité.

Seuil : aucun axe sous 4 sur l'écart et l'absence de sentiment formulé.

## 8. Interfaces

- Amont : `poet`.
- Voisins : `poetry/free-verse`.
