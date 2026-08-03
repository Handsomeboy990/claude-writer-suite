---
name: political-fiction
description: Écrit un roman politique : principe de la double échelle, mécanique du pouvoir, documentation institutionnelle, personnages non réductibles à leur fonction, réunions traitées comme des scènes de conflit. À utiliser pour un récit d'institutions, de campagne ou de décision publique.
license: MIT
metadata:
  category: genres
  version: 1.0.0
  depends_on: [writing-constitution, research-director, character-psychologist]
  outputs: [cartographie-des-forces, plan-politique]
---

# Political Fiction

Le roman politique montre comment une décision se fabrique. Il ne prend pas
parti par le discours : il prend parti par ce qu'il choisit de montrer.

## 1. Contrat de lecture

Le lecteur exige : des mécanismes de pouvoir exacts, des acteurs rationnels
selon leurs intérêts, une absence de manichéisme, et des conséquences
concrètes sur des gens ordinaires.

## 2. Principe de la double échelle

Toute scène de pouvoir est doublée par une scène d'effet. Une décision prise
en réunion se paye trois chapitres plus loin chez quelqu'un qui ignore la
réunion. La force du genre tient dans cet écart.

## 3. Mécanique du pouvoir

- Le pouvoir n'est pas une possession, c'est une circulation. Établir qui doit
  quoi à qui.
- Toute décision résulte d'un arbitrage entre plusieurs contraintes, dont
  aucune n'est le bien commun exclusivement.
- Les acteurs agissent selon des intérêts compréhensibles : réélection,
  loyauté, dette, peur, carrière, conviction.
- L'appareil administratif ralentit, déforme et parfois neutralise la décision.
  Ce délai est un moteur dramatique.
- L'information est une monnaie : qui sait avant, qui fait savoir, qui retient.

## 4. Documentation

Niveau 3 obligatoire sur : circuit de décision réel, hiérarchie et
compétences, calendrier institutionnel, budget et ordre de grandeur,
procédures de nomination et de contrôle, rôle de la presse.

Une erreur de procédure décrédibilise l'ensemble du roman auprès du lecteur
informé.

## 5. Personnages

- Aucun personnage n'est réductible à sa fonction.
- L'adversaire politique du protagoniste doit avoir un argument que le lecteur
  ne peut pas balayer.
- Le collaborateur subalterne est souvent le meilleur point de vue : il voit
  tout et ne décide rien.
- Prévoir un personnage qui subit sans comprendre, pour l'échelle basse.

## 6. Écriture

- Les scènes de réunion sont des scènes de conflit d'objectifs : appliquer
  `scene-builder` sans exception.
- Le jargon institutionnel est employé, jamais expliqué.
- Les chiffres sont concrets et rares.
- Le discours public est écrit comme un objet, avec ses effets sur ceux qui
  l'écoutent, pas comme une tribune de l'auteur.

## 7. Clichés à retourner ou proscrire

- Le complot unique qui explique tout.
- Le journaliste solitaire qui fait tomber un système.
- Le politicien intégralement cynique ou intégralement pur.
- La scène de couloir où tout se décide en trois répliques.
- Le peuple représenté comme une masse homogène.

## 8. Contrôles de sortie

- Chaque décision majeure est doublée par une scène d'effet.
- Chaque acteur a un intérêt formulable.
- La procédure représentée est exacte.
- L'adversaire a un argument recevable.
- Aucune thèse énoncée par un personnage porte-parole.

## 9. Auto-critique

Onze axes de la constitution, plus quatre axes de genre : exactitude
institutionnelle, absence de manichéisme, tenue de la double échelle,
incarnation des conséquences.

Seuil : aucun axe sous 3, moyenne minimale 4 sur exactitude institutionnelle
et absence de manichéisme.

## 10. Interfaces

- Amont : `research-director`.
- Voisins : `genres/espionage`, `genres/dystopian`, `genres/historical-fiction`.
