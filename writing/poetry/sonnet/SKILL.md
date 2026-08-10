---
name: sonnet
description: Écrit un sonnet français, italien ou anglais : dispositions de rimes, place de la volte, économie strophique, contraintes techniques, composition à partir du vers de bascule. À utiliser pour écrire ou corriger un sonnet ou une forme fixe en quatorze vers.
license: MIT
metadata:
  category: poetry
  version: 1.0.0
  depends_on: [writing-constitution, poet]
  outputs: [sonnets]
---

# Sonnet

Forme fixe de quatorze vers. Sa difficulté n'est pas le compte : c'est le
retournement, qui doit arriver au bon endroit et paraître inévitable.

## 1. Structures

| Type | Strophes | Rimes des tercets | Caractère |
|---|---|---|---|
| Français, dit marotique | 2 quatrains, 2 tercets | CCD EED | équilibre, clôture nette |
| Italien, dit pétrarquien | 2 quatrains, 2 tercets | CDE CDE | fluidité, ouverture |
| Anglais, dit shakespearien | 3 quatrains, 1 distique | ABAB CDCD EFEF GG | démonstration puis pointe |

Les quatrains français emploient des rimes embrassées ABBA ABBA.
Mètre par défaut : alexandrin. Le décasyllabe est admis.

## 2. Le retournement

Le sonnet vit de la volte, qui sépare le poème en deux mouvements.

- Sonnet français et italien : volte entre le second quatrain et le premier
  tercet, au vers 9.
- Sonnet anglais : volte au vers 13, dans le distique final.

La volte est un changement de temps, de personne, d'échelle, de lieu ou de
certitude. Elle n'est jamais annoncée par un connecteur logique lourd.

## 3. Économie interne

- Quatrain 1 : poser la situation concrète.
- Quatrain 2 : approfondir, compliquer, introduire une résistance.
- Tercet 1 : basculer.
- Tercet 2 : conclure sans expliquer.

Le dernier vers est la position la plus forte du poème. Il ne résume pas, il
déplace.

## 4. Contraintes techniques

- Alternance obligatoire des rimes masculines et féminines.
- Rimes suffisantes au minimum, dans l'idéal deux rimes riches par sonnet, pas
  davantage.
- Aucune rime répétée dans le poème.
- Aucun mot de rime employé deux fois.
- Pas de cheville, pas d'inversion artificielle.
- Aucun enjambement entre les strophes du sonnet classique, sauf effet unique
  et assumé.

## 5. Procédure

1. Écrire d'abord le vers 9 ou le vers 14, celui qui porte la bascule.
2. Trouver les quatre mots de rime des quatrains avant d'écrire les quatrains.
3. Composer les quatrains vers la bascule.
4. Composer les tercets à partir de la bascule.
5. Vérifier le compte de chaque vers à voix haute.
6. Vérifier l'alternance des rimes.
7. Supprimer toute cheville, quitte à refaire une rime entière.

## 6. Interdits

- Sujet abstrait sans ancrage concret.
- Vocabulaire de convention poétique : azur, aurore, langueur, sans travail
  de déplacement.
- Volte absente ou placée hors de sa position.
- Dernier vers explicatif.

## 7. Auto-critique

Axes notés de 0 à 5 : exactitude métrique, qualité des rimes, force de la
volte, nécessité de chaque vers, dernier vers, absence de cheville,
originalité, émotion.

Seuil : aucun axe sous 4 sur exactitude métrique et volte.

## 8. Interfaces

- Amont : `poet`.
- Contrôle : `quality/literary-critic`.
