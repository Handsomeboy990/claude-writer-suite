---
name: prose-poetry
description: Écrit un poème en prose : bloc compact, quatre forces de cohésion (rythme, champ lexical, progression sensorielle, clôture), familles de formes, pièges du lyrisme et de la chute explicative. À utiliser pour une prose poétique, une notation ou un fragment.
license: MIT
metadata:
  category: poetry
  version: 1.0.0
  depends_on: [writing-constitution, poet]
  outputs: [proses-poetiques]
---

# Prose Poetry

Le poème en prose n'a ni vers ni retour à la ligne, mais il obéit à une
nécessité formelle interne. Ce qui le distingue d'un fragment de récit, c'est
qu'il ne progresse pas : il s'approfondit.

## 1. Caractéristiques

- Bloc compact, généralement de cinq à trente lignes.
- Pas de vers, pas de rime obligatoire, mais un travail rythmique constant.
- Unité de ton, d'image ou de lieu.
- Pas d'intrigue. S'il y a un récit, il est prétexte.
- Clôture par déplacement, jamais par conclusion.

## 2. Ce qui tient le texte

Puisque le vers ne soutient plus, quatre forces le remplacent :

1. Le rythme de la phrase, avec des retours de structure et des variations de
   longueur.
2. L'unité de champ lexical, tenue avec discipline.
3. La progression sensorielle : le texte change de sens perceptif, du visuel
   au sonore, du sonore au tactile.
4. La dernière phrase, qui doit ouvrir plutôt que refermer.

## 3. Écriture

- Phrases de longueurs très contrastées. Une phrase longue de cinq lignes
  suivie d'une phrase de trois mots produit l'essentiel de l'effet.
- Répétition d'un mot ou d'une structure toutes les trois ou quatre phrases,
  employée comme scansion.
- Le concret domine : objets, gestes, matières, prix, noms propres.
- Aucun commentaire du sens par le texte lui-même.
- La ponctuation est l'unique instrument de coupe : elle est travaillée
  comme une partition.

## 4. Familles

| Famille | Principe |
|---|---|
| Notation | consigner un lieu ou un instant, sans intention |
| Fable brève | un événement minuscule qui bascule dans l'étrange |
| Portrait | un être saisi par ses gestes et ses objets |
| Lettre ou adresse | un destinataire non nommé, une parole retenue |
| Inventaire | une liste qui devient un récit par accumulation |

## 5. Pièges

- Le lyrisme sans objet.
- Le récit qui prend le dessus et transforme le texte en nouvelle courte.
- L'accumulation d'images sans progression sensorielle.
- La chute explicative.
- La ponctuation relâchée, qui détruit le rythme.

## 6. Procédure

1. Choisir un lieu, un instant ou un objet unique.
2. Écrire d'un jet, sans coupe.
3. Retirer toute abstraction et tout commentaire.
4. Travailler les longueurs de phrase par contraste.
5. Installer une reprise, employée trois fois.
6. Réécrire la dernière phrase au moins cinq fois.
7. Lire à voix haute, ajuster la ponctuation.

## 7. Auto-critique

Axes notés de 0 à 5 : tenue rythmique, unité, progression sensorielle,
concrétude, qualité de la clôture, absence de récit envahissant, absence de
commentaire.

Seuil : aucun axe sous 3, moyenne minimale 4 sur tenue rythmique et clôture.

## 8. Interfaces

- Amont : `poet`.
- Voisins : `poetry/free-verse`, `genres/magical-realism`.
