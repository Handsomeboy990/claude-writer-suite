---
name: character-psychologist
category: core
version: 1.0.0
depends_on: [writing-constitution]
outputs: [fiches-personnages, arcs, cartographie-relationnelle]
---

# Character Psychologist

Construction de personnages complexes, cohérents et capables de surprendre
sans se contredire.

## 1. Principe directeur

Un personnage n'est pas une somme de traits. C'est un système de tensions.
On le construit en cherchant la contradiction interne qui le rend prévisible
dans sa nature et imprévisible dans ses actes.

## 2. Noyau en sept champs

Ces sept champs suffisent à écrire n'importe quelle scène du personnage.

1. Désir conscient : ce qu'il poursuit et peut formuler.
2. Besoin inconscient : ce qui le guérirait, et qu'il refuse.
3. Blessure fondatrice : événement précis, daté, avec un lieu et un témoin.
4. Mensonge : la croyance fausse née de la blessure, formulée à la première
   personne.
5. Peur : la conséquence redoutée si le mensonge tombe.
6. Défense : le comportement qui protège le mensonge, visible dès la
   première scène.
7. Contradiction : le trait qui va contre tout ce qui précède, et qui rend le
   personnage vivant.

Exemple de mensonge : `Si je m'arrête, tout le monde s'arrête.`
Défense correspondante : il ne délègue rien, il arrive avant les autres, il
refuse d'être malade.

## 3. Couches d'accès

Trois couches, révélées dans cet ordre au lecteur :

- Couche publique : ce que les inconnus voient, y compris ce qu'il met en
  scène volontairement.
- Couche privée : ce que voient les proches, ses relâchements, ses colères.
- Couche secrète : ce qu'il ne montre à personne, souvent lié à la blessure.

Chaque révélation de couche est un événement dramatique. Ne pas descendre de
deux couches dans la même scène.

## 4. Comportement observable

Traduire la psychologie en signes, seul matériau utilisable par le romancier :

| Élément intérieur | Traduction concrète |
|---|---|
| Peur de perdre le contrôle | arrive en avance, vérifie deux fois, refuse qu'on conduise |
| Honte sociale | corrige son langage, évite certains lieux, paye trop vite |
| Deuil non fait | conserve un objet, garde une habitude devenue inutile |
| Colère refoulée | politesse excessive, précision du vocabulaire, gestes lents |
| Besoin d'approbation | reformule pour être compris, rit avant l'autre |

Le tableau se prolonge dans `resources/table-comportements.md`.

## 5. Voix du personnage

Renseigner, pour chaque personnage porteur de dialogue :

- deux mots qu'il emploie souvent ;
- deux mots qu'il n'emploierait jamais ;
- longueur moyenne de ses répliques ;
- rapport à la question et au mensonge ;
- ce qu'il fait quand il ne sait pas quoi répondre.

## 6. Arc et transformation

Quatre trajectoires possibles :

1. Arc positif : le mensonge tombe, le personnage change et paye le prix.
2. Arc négatif : le mensonge gagne, le personnage se referme.
3. Arc plat : le personnage ne change pas, il change le monde autour de lui.
4. Arc de désillusion : il découvre que sa vérité était le mensonge d'un autre.

Points de passage obligés : scène qui prouve le mensonge, scène qui le coûte,
scène de choix. Sans scène de choix explicite, la transformation est affirmée
et non démontrée : le lecteur ne la croira pas.

## 7. Personnages secondaires

- Chaque secondaire a un désir propre, indépendant du protagoniste.
- Il a une vie qui continue hors champ, matérialisée par au moins un détail
  non expliqué.
- Il ne doit jamais être présent uniquement pour poser une question à la
  place du lecteur.
- Trois secondaires bien tenus valent mieux que dix silhouettes.

## 8. Cartographie relationnelle

Pour chaque couple de personnages significatif, noter :

- ce que A veut de B ;
- ce que B croit que A veut ;
- la dette ou le pouvoir qui circule entre eux ;
- la phrase qu'ils ne se diront jamais ;
- l'événement qui pourrait renverser la relation.

## 9. Pièges

- Le passé traumatique comme seule explication de tout comportement.
- Le personnage compétent en tout, faible seulement par modestie.
- La contradiction décorative, jamais mise en jeu par l'intrigue.
- Le méchant sans logique interne défendable de son point de vue.
- L'évolution soudaine, non préparée, à la faveur du climax.

## 10. Auto-critique

Axes notés de 0 à 5 : cohérence interne, force de la contradiction, lisibilité
du désir, profondeur du besoin, traduction comportementale, singularité de la
voix, crédibilité de l'arc, autonomie des secondaires, absence de stéréotype,
capacité à surprendre.

Seuil : aucun axe sous 3, moyenne minimale 3,8.

## 11. Interfaces

- Amont : `research-director` pour les milieux et les métiers.
- Latéral : `dialogue-master`, `scene-builder`.
- Contrôle : `continuity-manager`, `quality/beta-reader`.
