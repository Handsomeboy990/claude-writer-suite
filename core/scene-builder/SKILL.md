---
name: scene-builder
description: Construit des scènes fortes : objectif du personnage, conflit en escalade, issue coûteuse, réaction, dilemme, décision. Ancrage spatial, sous-texte, rythme, irréversibilité. À utiliser pour écrire une scène, réparer une scène plate, ou vérifier qu'une scène change l'état du récit.
license: MIT
metadata:
  category: core
  version: 1.0.0
  depends_on: [writing-constitution, chapter-architect]
  outputs: [scenes-redigees, fiches-de-scene]
---

# Scene Builder

Construit des scènes qui tiennent debout seules : objectif, conflit, coût,
conséquence. Ce skill est l'unité de production principale du roman.

## 1. Définition de travail

Une scène est un bloc continu de temps et de lieu où un personnage veut
quelque chose, rencontre une résistance, et sort dans un état différent de
celui où il est entré. Sans changement d'état, il n'y a pas de scène : il y a
du remplissage.

## 2. Structure canonique

### Bloc d'action

1. Objectif : ce que le personnage de point de vue veut obtenir ici et
   maintenant, formulable en une phrase à l'infinitif.
2. Conflit : ce qui s'y oppose, en escalade sur au moins trois paliers.
3. Issue : échec, réussite coûteuse, ou réussite qui aggrave la situation.
   La réussite simple est réservée à moins d'une scène sur six.

### Bloc de réaction

4. Réaction : réponse émotionnelle immédiate, corporelle avant d'être
   mentale.
5. Dilemme : deux options mauvaises, formulées explicitement ou non.
6. Décision : nouvel objectif qui devient l'objectif de la scène suivante.

Le bloc de réaction peut être resserré en trois lignes dans un thriller, ou
occuper une scène complète dans un roman intime. Il n'est jamais supprimé,
sinon les événements s'enchaînent sans être vécus.

## 3. Protocole de rédaction

### Étape 1 : fixer la valeur

Écrire la valeur qui bascule et son signe : liberté vers captivité, confiance
vers soupçon, dette vers acquittement. Une seule valeur par scène.

### Étape 2 : entrer tard, sortir tôt

Commencer au plus proche du conflit. Couper l'arrivée, la salutation,
l'installation. Terminer sur le dernier élément signifiant, sans épilogue de
scène.

### Étape 3 : ancrer l'espace en trois touches

Trois éléments concrets suffisent à installer un lieu : une matière, un son,
une contrainte physique. La contrainte physique est la plus rentable, car elle
crée du jeu : une porte qui ferme mal, une chaleur qui oblige à se lever, un
sol qui rend le déplacement bruyant.

### Étape 4 : distribuer les corps

Savoir à tout moment où se trouve chaque personnage, ce qu'il fait de ses
mains, ce qu'il regarde. Une scène de dialogue sans blocage corporel devient
deux voix dans le vide.

### Étape 5 : écrire en sous-texte

Ce que les personnages disent recouvre ce qu'ils veulent. Méthode : écrire
d'abord la version explicite où tout est dit, puis la réécrire en supprimant
toute phrase qui nomme directement l'enjeu, en la remplaçant par un objet,
un geste ou un détour.

### Étape 6 : régler le rythme interne

- Phrases longues pour la durée, phrases brèves pour l'impact.
- Réduire la longueur moyenne des paragraphes à mesure que la tension monte.
- Insérer une respiration après un pic, jamais avant.
- Éviter plus de deux paragraphes descriptifs consécutifs en scène tendue.

### Étape 7 : vérifier l'irréversibilité

À la fin de la scène, quelque chose ne peut plus être défait : une parole
prononcée, une porte franchie, une information reçue, un objet cassé. Sinon,
la scène est réécrite ou fusionnée.

## 4. Types de scènes et pièges

| Type | Piège dominant | Correction |
|---|---|---|
| Dialogue d'information | exposition frontale | donner l'information à contrecoeur |
| Confrontation | montée linéaire | insérer une tentative de désescalade qui échoue |
| Action | énumération de gestes | ancrer sur un objectif partiel toutes les cinq lignes |
| Voyage | résumé sans enjeu | limiter à ce qui change une relation |
| Retrouvailles | attendrissement | placer un désaccord préalable non résolu |
| Révélation | discours explicatif | faire résister celui qui sait |

## 5. Contrôles de sortie

- La scène a un objectif formulable.
- Le conflit escalade sur trois paliers au moins.
- L'état final diffère de l'état initial.
- Le lecteur sait où se trouvent les corps.
- Aucun personnage ne dit ce qu'il pourrait montrer.
- La constitution est respectée sur les dialogues et les flashbacks.

## 6. Auto-critique

Axes notés de 0 à 5 : clarté de l'objectif, escalade du conflit,
irréversibilité, ancrage sensoriel, sous-texte, rythme, justesse des
dialogues, économie, originalité de traitement, émotion produite.

Seuil : aucun axe sous 3, moyenne minimale 3,8. Toute scène sous le seuil est
réécrite entièrement, pas retouchée.

## 7. Interfaces

- Amont : `chapter-architect`, `character-psychologist`.
- Latéral : `dialogue-master`, `immersion-director`, `narrator`.
- Contrôle : `quality/self-critique-protocol`.
