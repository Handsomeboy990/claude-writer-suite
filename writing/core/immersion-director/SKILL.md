---
name: immersion-director
description: Crée l'immersion culturelle et sensorielle : lieux, cultures, langues, climats, paysages, traditions, gastronomie, sons, odeurs. Dosage par type de scène et contrôle anti-exotisme. À utiliser pour rendre un lieu vivant, ou quand une description sonne comme un dépliant touristique.
license: MIT
metadata:
  category: core
  version: 1.0.0
  depends_on: [writing-constitution, world-builder, research-director]
  outputs: [dossier-sensoriel, passages-immersifs]
---

# Immersion Director

Responsable de l'immersion culturelle et sensorielle complète. Le lecteur doit
sortir du livre en ayant l'impression d'avoir habité un lieu, pas d'avoir lu
sa description.

## 1. Doctrine

L'immersion n'est pas un volume de description. C'est un rapport de
familiarité. Un lieu devient réel quand il gêne, quand il use, quand il sent,
quand il oblige à faire un détour.

Trois lois :

1. Loi du détail unique. Un détail précis et vérifiable installe plus qu'un
   paragraphe entier.
2. Loi de l'usage. Le monde se révèle par ce que les personnages en font, pas
   par ce qu'ils en disent.
3. Loi de la friction. On ne ressent que ce qui résiste : la chaleur qui
   ralentit, la poussière qui colle, la langue qu'on ne comprend pas.

## 2. Les neuf canaux

Chaque scène importante mobilise au moins trois canaux, jamais les neuf.

### 2.1 Lieux

Ne pas décrire l'espace, décrire ce qu'il impose. Hauteur de plafond, largeur
d'un couloir, distance jusqu'au point d'eau, endroit où l'on se met pour être
vu, endroit où l'on se met pour ne pas l'être.

### 2.2 Cultures

Ce qui se fait, ce qui ne se fait pas, ce que l'on doit accepter, à qui l'on
parle en premier, qui mange avant qui, ce qu'il est impoli de refuser. La
culture s'écrit en règles implicites transgressées par quelqu'un.

### 2.3 Langues

Alternance de langues, registres, langue du travail contre langue de
l'intimité, ce qui ne se dit que dans une seule langue. Aucune traduction
entre parenthèses.

### 2.4 Climats

Le climat est un personnage antagoniste. Il modifie les vêtements, le sommeil,
l'humeur, l'odeur, les horaires, le prix des choses. Une saison des pluies ne
se décrit pas : elle décale un rendez-vous.

### 2.5 Paysages

Trois plans : ce que l'on voit au loin, ce que l'on voit à hauteur d'homme, ce
que l'on a sous les pieds. Le troisième plan est le plus négligé et le plus
efficace.

### 2.6 Traditions

Rites de passage, funérailles, mariages, salutations, dettes d'honneur.
Toujours écrites du point de vue de quelqu'un qui y participe, jamais d'un
observateur ethnographique.

### 2.7 Gastronomie

Ce que l'on mange, à quelle heure, avec quoi, dans quel ordre, ce que coûte un
plat, ce qui se mange avec les doigts, ce qui se partage, ce qui se refuse.
Le goût est un accès direct à la mémoire et donc à l'émotion.

### 2.8 Sons

Sons de fond permanents, sons qui signalent l'heure, sons qui annoncent le
danger, silence anormal. Un lieu se reconnaît d'abord à son bruit de fond.

### 2.9 Odeurs

Canal le plus puissant et le plus sous-employé. Une odeur par lieu majeur,
tenue tout au long du roman, suffit à créer un ancrage durable et à déclencher
les flashbacks de façon légitime.

## 3. Protocole d'immersion d'une scène

1. Identifier le canal dominant du lieu, celui que ce lieu impose.
2. Choisir deux canaux secondaires.
3. Écrire trois détails concrets, dont un qui gêne le personnage.
4. Vérifier que chaque détail est perçu par quelqu'un et coloré par son état.
5. Supprimer tout détail qui ne pourrait pas être remarqué à ce moment
   précis, dans cet état émotionnel.
6. Vérifier qu'aucun paragraphe descriptif ne dépasse cinq lignes en scène
   tendue.

## 4. Dosage

| Moment | Densité descriptive |
|---|---|
| Ouverture de chapitre | forte, trois à cinq détails |
| Scène d'action | faible, un détail par pic |
| Dialogue tendu | un détail toutes les dix répliques, en attribution |
| Scène de deuil ou de mémoire | forte, canal odeur et son |
| Transition, déplacement | moyenne, canal paysage et climat |

## 5. Contrôle anti-exotisme

Questions à poser sur tout passage immersif :

- Ce détail est-il présent parce qu'il est vrai, ou parce qu'il est pittoresque ?
- Un habitant du lieu le remarquerait-il ?
- Le passage traite-t-il cette culture avec le même niveau de détail que celle
  du lecteur supposé ?
- Un lecteur issu de ce lieu se reconnaîtrait-il, ou se sentirait-il regardé ?

Une seule réponse défavorable impose la réécriture.

## 6. Auto-critique

Axes notés de 0 à 5 : précision des détails, variété des canaux, absence
d'exotisme, intégration au conflit, sobriété, cohérence avec la bible du
monde, mémorabilité, effet émotionnel, justesse culturelle, absence de
catalogue.

Seuil : aucun axe sous 3, moyenne minimale 3,8.

## 7. Interfaces

- Amont : `world-builder`, `research-director`.
- Latéral : `scene-builder`.
- Contrôle : `quality/literary-editor`, `quality/beta-reader`.
