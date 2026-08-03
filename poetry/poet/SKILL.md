---
name: poet
category: poetry
version: 1.0.0
depends_on: [writing-constitution]
outputs: [poemes, note-prosodique]
---

# Poet

Skill général de poésie. Il porte la prosodie française, le travail de
l'image et les procédures de révision applicables à toutes les formes.

## 1. Principes

- Un poème ne dit pas une émotion, il la produit par la forme.
- La contrainte n'est pas un obstacle : elle force le déplacement qui fait
  trouver ce que l'on ne cherchait pas.
- Le premier vers venu est presque toujours un vers entendu ailleurs.
- Un poème se juge à voix haute. Ce qui ne tient pas à l'oreille ne tient pas.

## 2. Prosodie française

### 2.1 Compte des syllabes

- La syllabe finale muette ne compte pas en fin de vers.
- Le e muet compte à l'intérieur du vers s'il est suivi d'une consonne,
  ne compte pas s'il est suivi d'une voyelle ou en fin de vers.
- La diérèse sépare deux voyelles en deux syllabes, la synérèse les réunit.
  Le choix est fixé par l'usage classique et par l'oreille.

### 2.2 Mètres

| Mètre | Syllabes | Caractère |
|---|---|---|
| Alexandrin | 12 | ampleur, pensée, récit |
| Décasyllabe | 10 | tension, ancienneté |
| Octosyllabe | 8 | vivacité, chanson |
| Heptasyllabe | 7 | déséquilibre, légèreté |
| Pentasyllabe | 5 | fragment, souffle court |

### 2.3 Césure et coupes

L'alexandrin classique se coupe à l'hémistiche, six plus six. Le trimètre
romantique le découpe en quatre plus quatre plus quatre. Une césure qui tombe
à l'intérieur d'un mot ou après un e muet est une faute, sauf effet cherché
et tenu.

### 2.4 Rimes

- Rime pauvre : un son commun. Rime suffisante : deux. Rime riche : trois ou
  plus.
- Alternance des rimes masculines et féminines, la rime féminine se terminant
  par un e muet.
- Dispositions : plates AABB, croisées ABAB, embrassées ABBA.
- Hiatus, rencontre de deux voyelles entre deux mots, à éviter en vers
  classique.
- Une rime trop riche attire l'attention sur elle et affaiblit le sens.

### 2.5 Enjambement

Rejet, contre-rejet et enjambement créent une tension entre la syntaxe et le
mètre. Ils ne s'emploient pas par commodité : chaque enjambement doit produire
un effet de sens.

## 3. Image

- Une image forte relie deux domaines éloignés par une nécessité, pas par une
  ressemblance décorative.
- Vérifier la cohérence des images filées : aucun changement de domaine en
  cours de route.
- Bannir les images fossiles : cristal des larmes, océan des regrets, oiseau
  de la liberté.
- Le concret précis vaut mieux que l'abstrait noble : un nom d'outil, un
  nom de plante, un prix, une heure.

## 4. Son

- Allitérations et assonances employées avec parcimonie et intention.
- Éviter les rimes internes involontaires et les cacophonies.
- Travailler la longueur des voyelles et la place des consonnes occlusives
  pour ralentir ou accélérer.
- Lire à voix haute est la seule vérification valable.

## 5. Procédure de composition

1. Trouver le noyau : une image, une phrase entendue, une contrainte.
2. Écrire une version longue, sans forme, pour trouver la matière.
3. Choisir la forme en fonction de ce que la matière demande.
4. Composer en respectant strictement la contrainte choisie.
5. Retirer le tiers le plus faible.
6. Lire à voix haute, corriger ce qui bute.
7. Laisser reposer, relire, retirer encore.

## 6. Interdits

- Aucun emoji, aucun tiret cadratin, conformément à la constitution.
- Aucune inversion syntaxique artificielle pour sauver une rime.
- Aucun archaïsme non motivé, aucun `ô` lyrique par défaut.
- Aucune ponctuation d'emphase, aucun point d'exclamation en fin de poème.
- Aucun titre explicatif du poème.

## 7. Auto-critique

Axes notés de 0 à 5 : justesse prosodique, force des images, nécessité de
chaque vers, tenue sonore, originalité, émotion produite, absence de
cliché, tenue de la forme choisie.

Seuil : aucun axe sous 3, moyenne minimale 4. Un poème publiable exige
davantage qu'une prose publiable.

## 8. Interfaces

- Aval : `poetry/sonnet`, `poetry/haiku`, `poetry/free-verse`,
  `poetry/prose-poetry`.
- Contrôle : `quality/literary-critic`.
