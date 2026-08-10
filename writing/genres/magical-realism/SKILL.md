---
name: magical-realism
description: Écrit du réalisme magique : règle du non-étonnement, ancrage social et matériel, formulation ordinaire de l'extraordinaire, conséquences pratiques, voix de conteur, sens laissé ouvert. À utiliser pour un récit où le merveilleux est traité comme un fait banal.
license: MIT
metadata:
  category: genres
  version: 1.0.0
  depends_on: [writing-constitution, immersion-director, narrator]
  outputs: [charte-du-merveilleux, plan-realiste-magique]
---

# Magical Realism

Le réalisme magique ne mélange pas deux mondes : il n'en a qu'un, où
l'extraordinaire est traité avec la même banalité que le reste.

## 1. Contrat de lecture

Le lecteur exige : un ancrage social et matériel fort, un merveilleux non
expliqué, un narrateur qui ne s'étonne pas, et une signification qui reste
ouverte.

## 2. Règle du non-étonnement

Le narrateur et les personnages ne s'étonnent pas de l'événement
extraordinaire. Ils s'occupent de ses conséquences pratiques.

Test : si un personnage demande comment c'est possible, le texte a basculé
dans le fantastique et n'appartient plus au genre.

## 3. Ancrage

- Le merveilleux ne fonctionne que sur un socle réaliste dense : prix,
  travail, familles, administration, maladies, saisons.
- Plus l'événement est extraordinaire, plus la phrase qui le porte doit être
  ordinaire.
- Le merveilleux est souvent lié à une réalité sociale : deuil, exil, mémoire
  effacée, violence politique. C'est ce lien qui donne son sens au genre.

## 4. Écriture du merveilleux

- Une seule phrase, sans emphase, insérée dans une énumération de faits
  ordinaires.
- Aucune explication, aucune règle, aucun système. La cohérence est
  émotionnelle, pas mécanique.
- Les conséquences pratiques sont traitées sérieusement : qui nettoie, qui
  paye, ce que disent les voisins.
- Le merveilleux peut cesser sans raison, comme il est venu.

## 5. Voix

- Voix de conteur, souvent proche de l'oralité, avec des reprises et des
  digressions maîtrisées.
- Temps longs, générations, répétitions de motifs à travers les époques.
- Le narrateur peut savoir des choses qu'il n'a pas vues, à condition de ne
  jamais justifier ce savoir.
- Le discours indirect libre est l'outil central, voir `core/narrator`.

## 6. Clichés à retourner ou proscrire

- L'exotisme comme justification du merveilleux.
- Le merveilleux uniquement décoratif, sans conséquence sociale.
- Le personnage qui devient fou pour expliquer le surnaturel.
- La métaphore explicitée par le texte lui-même.
- La copie de motifs déjà employés par les auteurs fondateurs du genre.

## 7. Contrôles de sortie

- Aucun personnage ne demande d'explication.
- Chaque événement merveilleux a une conséquence pratique traitée.
- Le socle réaliste occupe la majorité du texte.
- Aucune règle systématique n'est énoncée.
- La signification reste ouverte, non énoncée par le narrateur.

## 8. Auto-critique

Onze axes de la constitution, plus quatre axes de genre : tenue du non
étonnement, densité du socle réaliste, ordinaire de la formulation,
ouverture du sens.

Seuil : aucun axe sous 3, moyenne minimale 4 sur tenue du non-étonnement.

## 9. Interfaces

- Amont : `narrator`, `immersion-director`.
- Voisins : `genres/fantasy`, `poetry/prose-poetry`.
