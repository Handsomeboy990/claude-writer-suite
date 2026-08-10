---
name: adventure
description: Écrit un roman d'aventure : itinéraire comme structure, comptabilité des ressources et attrition, compétence démontrée, territoire contraignant, rythme déplacement et halte, retour obligatoire. À utiliser pour un récit de voyage, d'expédition ou de survie.
license: MIT
metadata:
  category: genres
  version: 1.0.0
  depends_on: [writing-constitution, scene-builder, immersion-director]
  outputs: [itineraire, plan-d-aventure]
---

# Adventure

Le roman d'aventure repose sur le mouvement, l'obstacle physique et la
transformation par le trajet. Il n'est pas un enchaînement de péripéties : il
est une géographie qui use.

## 1. Contrat de lecture

Le lecteur exige : un but clair, un territoire hostile et documenté, des
compétences concrètes, une escalade des obstacles, et un retour qui change le
sens du départ.

## 2. Construction de l'itinéraire

L'itinéraire est la structure. Chaque étape doit :

- présenter un obstacle d'une nature différente de la précédente ;
- coûter une ressource : temps, matériel, santé, allié, illusion ;
- révéler quelque chose sur un personnage.

Trois obstacles de même nature à la suite produisent une lassitude immédiate.
Alterner : nature, humain, technique, moral, interne.

## 3. Ressources et attrition

Tenir une comptabilité stricte : vivres, eau, munitions, argent, carburant,
santé, jours restants. L'aventure devient tendue quand le lecteur peut compter
avec le personnage.

Règle d'attrition : ce qui est consommé ne se reconstitue pas sans scène. Un
sac qui contient toujours ce qu'il faut détruit la tension.

## 4. Compétence

- Le protagoniste sait faire des choses précises et vérifiables. La compétence
  se montre en action, jamais en présentation.
- Il ignore autre chose, et cette ignorance doit lui coûter au moins une fois.
- L'apprentissage en cours de route est un moteur : montrer l'échec puis la
  maîtrise.

## 5. Territoire

Appliquer `immersion-director` sans exception. Le territoire n'est pas un
décor : il impose des horaires, des détours, des vêtements, des rencontres.
Le climat doit décider au moins une fois à la place des personnages.

Les populations rencontrées ne sont ni hostiles par nature ni serviables par
fonction. Elles ont leurs propres affaires, dans lesquelles les voyageurs
s'invitent.

## 6. Rythme

- Alterner déplacement et halte. La halte est le lieu du dialogue et de la
  révélation.
- Ne raconter un trajet que s'il transforme une relation ou consomme une
  ressource.
- Placer le pire obstacle avant l'avant-dernière étape, pas à la fin.
- Le retour, même bref, est obligatoire : il mesure le changement.

## 7. Clichés à retourner ou proscrire

- Le guide local qui trahit.
- La carte incomplète comme unique source de suspense.
- La tribu inventée comme obstacle exotique.
- Le trésor qui résout tous les problèmes.
- Le compagnon comique sans autre fonction.
- La blessure grave oubliée au chapitre suivant.

## 8. Contrôles de sortie

- Chaque étape coûte une ressource identifiable.
- Aucun obstacle répété dans sa nature.
- La comptabilité des ressources est cohérente de bout en bout.
- Les populations rencontrées ont des objectifs propres.
- Le retour existe et modifie le sens du départ.

## 9. Auto-critique

Onze axes de la constitution, plus quatre axes de genre : variété des
obstacles, cohérence de l'attrition, incarnation du territoire, justesse des
compétences.

Seuil : aucun axe sous 3, moyenne minimale 4 sur cohérence de l'attrition.

## 10. Interfaces

- Amont : `scene-builder`, `immersion-director`, `research-director`.
- Voisins : `genres/historical-fiction`, `genres/fantasy`.
