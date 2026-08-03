---
name: story-doctor
category: quality
version: 1.0.0
depends_on: [writing-constitution, self-critique-protocol]
outputs: [diagnostic-structurel, plan-de-reparation]
---

# Story Doctor

Analyse critique du récit au niveau structurel. Ce skill ne corrige pas les
phrases : il identifie pourquoi une histoire ne fonctionne pas et prescrit
une réparation.

## 1. Méthode de diagnostic

Un problème ressenti à un endroit trouve presque toujours sa cause ailleurs,
plus tôt. Ne jamais traiter le symptôme là où il apparaît.

| Symptôme ressenti | Cause probable, en amont |
|---|---|
| L'acte 2 est mou | l'objectif du protagoniste n'est pas assez cher payé |
| Le lecteur décroche au tiers | l'élément déclencheur est trop faible ou trop tardif |
| La fin déçoit | les promesses posées au début ne sont pas celles qui sont soldées |
| Le personnage principal est fade | il réagit au lieu d'agir, ou il n'a rien à perdre |
| Le méchant est ridicule | il n'a pas de logique défendable de son point de vue |
| Les scènes se ressemblent | une seule valeur bascule dans tout le roman |
| Le rythme est monotone | tous les chapitres ont le même signe et la même longueur |
| Les révélations tombent à plat | aucun indice n'a été planté, ou tous l'ont été |
| Le lecteur ne s'attache pas | le protagoniste n'a pas été montré compétent ou généreux tôt |
| Trop de personnages | plusieurs remplissent la même fonction dramatique |

## 2. Les dix contrôles structurels

1. La question dramatique est-elle formulable en une phrase fermée ?
2. L'élément déclencheur arrive-t-il avant douze pour cent du texte ?
3. Le protagoniste prend-il au moins trois décisions qui aggravent sa
   situation ?
4. Chaque acte se termine-t-il par une perte, non par un gain ?
5. Le point médian renverse-t-il l'information ou le rapport de force ?
6. Le climax résout-il la question dramatique par une action du protagoniste ?
7. Les trois promesses initiales sont-elles soldées ?
8. Chaque sous-intrigue modifie-t-elle l'intrigue principale ?
9. Existe-t-il un chapitre supprimable sans conséquence ? Si oui, le supprimer.
10. La dernière scène répond-elle à la première image ?

Un échec sur les contrôles 1, 6 ou 7 est bloquant.

## 3. Test de causalité

Relier les chapitres par `donc` ou `mais`, jamais par `puis`. Parcourir le
plan et vérifier la chaîne :

`Elle mesure la fissure, DONC elle rédige un rapport, MAIS le rapport
disparaît, DONC elle va voir le chef de secteur.`

Chaque `puis` détecté signale un maillon non causal, à réécrire ou à couper.

## 4. Test du protagoniste passif

Compter les scènes où le protagoniste :

- décide et agit ;
- réagit à une action extérieure ;
- reçoit une information sans rien faire.

Si le troisième groupe dépasse vingt pour cent, ou si le premier est
inférieur à quarante pour cent, le récit est porté par les événements et non
par un personnage. Réparation : transformer des réceptions en recherches
actives.

## 5. Test de l'enjeu

Trois questions, à poser à chaque acte :

- Que perd le protagoniste s'il échoue, concrètement ?
- Le lecteur connaît-il cette perte, ou seulement le narrateur ?
- La perte peut-elle survenir avant la fin, de façon partielle, pour prouver
  qu'elle est réelle ?

Un enjeu jamais réalisé partiellement n'est pas cru.

## 6. Prescriptions courantes

| Diagnostic | Prescription |
|---|---|
| Ventre mou | avancer une révélation de l'acte 3 au point médian |
| Fin plate | payer une dette narrative ancienne dans la dernière scène |
| Antagoniste faible | lui donner une victoire complète au premier tiers |
| Trop de personnages | fusionner deux fonctions identiques en un personnage |
| Manque de tension | ajouter une échéance concrète et visible |
| Manque d'attachement | ajouter une scène de compétence et une scène de générosité |
| Révélation prévisible | garder la révélation, changer le moment où le lecteur la comprend |
| Structure illisible | réduire à une seule ligne temporelle pendant l'acte 1 |

## 7. Rapport de diagnostic

Le rapport comporte, dans cet ordre :

1. ce qui fonctionne, en trois points maximum, sans complaisance ;
2. le diagnostic principal, un seul, formulé comme une cause ;
3. les diagnostics secondaires, cinq au maximum ;
4. le plan de réparation ordonné, avec les chapitres concernés ;
5. l'estimation de l'effort : retouche, réécriture partielle, restructuration.

## 8. Auto-critique

Axes notés de 0 à 5 : justesse du diagnostic principal, remontée aux causes,
absence de prescription cosmétique, hiérarchisation, faisabilité du plan,
respect de l'intention de l'auteur.

Seuil : aucun axe sous 4. Un diagnostic médiocre coûte plus cher qu'aucun
diagnostic.

## 9. Interfaces

- Amont : `novel-architect`, `chapter-architect`, manuscrit complet.
- Aval : `literary-editor`, `rewriting-engine`.
