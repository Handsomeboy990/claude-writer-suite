---
name: chapter-architect
category: core
version: 1.0.0
depends_on: [writing-constitution, novel-architect]
outputs: [decoupage-en-chapitres, fiche-chapitre, titres-de-chapitre]
---

# Chapter Architect

Transforme un plan général en chapitres jouables : découpage, fonction,
entrée, sortie, longueur, alternance des points de vue, titres.

## 1. Définition de travail

Un chapitre est une unité de tension complète. Il commence par une question
implicite et se termine par une réponse partielle qui en ouvre une autre.
Un chapitre qui ne change ni la situation, ni l'information, ni la relation
entre deux personnages est supprimé ou fusionné.

## 2. Entrées requises

- Plan général issu de `novel-architect`.
- Calendrier des révélations.
- Liste des points de vue autorisés.
- Contrainte de longueur globale.

## 3. Protocole

### Étape 1 : attribuer une fonction unique

Une fonction dominante par chapitre. En admettre deux affaiblit les deux.
Fonctions : installation, déclenchement, poursuite, obstacle, révélation,
renversement, respiration, confrontation, effondrement, résolution.

### Étape 2 : fixer la valeur d'entrée et la valeur de sortie

Chaque chapitre déplace une valeur sur un axe : sécurité vers danger, ignorance
vers savoir, lien vers rupture, espoir vers désespoir, ou l'inverse. Noter le
signe : positif, négatif, ou double basculement.

Interdiction de trois chapitres consécutifs de même signe. La monotonie de
signe produit une lassitude que le lecteur attribue au style.

### Étape 3 : définir l'entrée

L'entrée d'un chapitre se fait au plus tard possible dans la situation. Quatre
ouvertures fiables :

- en pleine action déjà engagée ;
- sur une réplique qui déséquilibre ;
- sur un détail concret qui contient la scène entière ;
- sur un déplacement, un corps qui va quelque part.

Ouvertures interdites : le réveil, la météo seule, le résumé du chapitre
précédent, la description d'un personnage devant un miroir.

### Étape 4 : définir la sortie

Cinq sorties efficaces :

1. décision irréversible ;
2. information nouvelle qui recadre tout le chapitre ;
3. arrivée d'un élément non prévu ;
4. question posée et non répondue ;
5. image qui prolonge l'émotion sans commentaire.

La sortie ne doit pas être un cliffhanger mécanique répété à chaque chapitre.
Au-delà d'un chapitre sur trois, l'effet s'annule et devient prévisible.

### Étape 5 : calibrer la longueur

- Roman littéraire : 2500 à 5000 mots par chapitre.
- Thriller, policier : 1200 à 2500 mots, coupes fréquentes.
- Fantasy et science-fiction : 3000 à 6000 mots, avec chapitres courts en
  alternance pour éviter la satiété descriptive.

Faire varier la longueur en fonction de la tension : plus la tension monte,
plus les chapitres raccourcissent. La longueur est un instrument de rythme,
pas une norme.

### Étape 6 : organiser l'alternance des points de vue

- Un seul point de vue par chapitre, sauf choix de narration omnisciente
  assumé et déclaré dans la bible.
- Ne pas introduire un nouveau point de vue après le premier tiers du roman
  sans nécessité structurelle.
- Un point de vue utilisé moins de trois fois est un point de vue à supprimer.
- Une alternance régulière rassure, une alternance rompue au bon moment
  inquiète. Rompre volontairement au seuil et à l'effondrement.

### Étape 7 : écrire le titre

Appliquer la section 5 de la constitution. Méthode en trois passes :

1. écrire dix titres sans filtre ;
2. éliminer ceux qui résument, ceux qui divulguent, ceux qui pourraient
   convenir à un autre chapitre ;
3. garder celui qui prend un second sens après lecture.

Contrôler ensuite la table des matières complète : lue d'affilée, elle doit
former une progression, presque un poème, jamais une liste d'étiquettes.

### Étape 8 : découper en scènes

Deux à quatre scènes par chapitre. Chaque scène est ensuite traitée par
`scene-builder`. Un chapitre à scène unique est réservé aux moments de
bascule.

## 4. Fiche chapitre

Gabarit dans `resources/fiche-chapitre.md`. Champs obligatoires : numéro,
titre, fonction, point de vue, lieu, date interne, durée écoulée, valeur
d'entrée, valeur de sortie, révélation, objets et indices plantés, promesse
ouverte, promesse fermée.

## 5. Erreurs fréquentes

- Ouvrir chaque chapitre par un résumé de ce que le lecteur vient de lire.
- Terminer chaque chapitre sur un cliffhanger, ce qui les neutralise tous.
- Aligner des chapitres de longueur identique.
- Changer de point de vue au milieu d'un chapitre sans marquage.
- Écrire un chapitre entier pour transmettre une seule information : elle se
  place dans un chapitre existant.

## 6. Auto-critique

Axes notés de 0 à 5 : nécessité du chapitre, force de l'entrée, force de la
sortie, alternance des signes, pertinence du point de vue, qualité du titre,
rythme interne, densité d'information, absence de redondance, tenue de la
promesse ouverte.

Seuil : aucun axe sous 3, moyenne minimale 3,8.

## 7. Interfaces

- Amont : `novel-architect`, `timeline-manager`.
- Aval : `scene-builder`, `narrator`.
- Contrôle : `continuity-manager`, `quality/story-doctor`.
