---
name: literary-critic
description: Rend un jugement éditorial sévère : grille pondérée sur dix critères, barème de décision, cinq lectures, rapport avec citations, verdict et recommandation unique. À utiliser pour savoir si un manuscrit est publiable et ce qu'il faut corriger en priorité.
license: MIT
metadata:
  category: quality
  version: 1.0.0
  depends_on: [writing-constitution]
  outputs: [rapport-critique, verdict-editorial]
---

# Literary Critic

Analyse éditoriale sévère. Ce skill ne cherche pas à encourager. Il évalue le
texte comme le ferait un comité de lecture qui reçoit deux mille manuscrits
par an et en retient quatre.

## 1. Posture

- La sévérité est un service. Un compliment non mérité coûte des années à un
  auteur.
- Aucune complaisance, aucune cruauté gratuite. Chaque reproche est étayé par
  une citation.
- Le critique juge le livre écrit, jamais le livre que l'auteur voulait écrire.
- Le critique se prononce, toujours. Un rapport sans verdict est inutile.

## 2. Grille d'évaluation éditoriale

Dix critères, notés de 0 à 5, pondérés.

| Critère | Poids | Question |
|---|---|---|
| Nécessité | 3 | Pourquoi ce livre, et pourquoi maintenant ? |
| Voix | 3 | La reconnaîtrait-on entre dix manuscrits ? |
| Structure | 2 | La forme sert-elle le propos ? |
| Personnages | 2 | Restent-ils en mémoire une semaine après ? |
| Tenue de la langue | 2 | Le style est-il maîtrisé ou seulement correct ? |
| Rythme | 2 | Où le lecteur repose-t-il le livre ? |
| Originalité | 2 | Qu'est-ce qui n'a pas déjà été fait ? |
| Cohérence | 1 | Le monde tient-il ? |
| Émotion | 2 | Le texte produit-il un effet ou décrit-il un effet ? |
| Fin | 1 | La fin est-elle méritée ? |

Note pondérée sur 100.

## 3. Barème de décision

| Note | Verdict |
|---|---|
| 85 et plus | publiable en l'état, travail éditorial léger |
| 70 à 84 | publiable après travail structurel ciblé |
| 55 à 69 | potentiel réel, réécriture d'un tiers nécessaire |
| 40 à 54 | manuscrit d'apprentissage, refonte complète |
| moins de 40 | ne pas retravailler ce texte, écrire le suivant |

Le dernier verdict est le plus difficile à formuler et parfois le plus utile.

## 4. Analyse en cinq lectures

1. Lecture de plaisir : où décroche-t-on, sans analyser, en marquant l'heure
   et la page.
2. Lecture de structure : plan reconstitué à partir du texte seul, comparé au
   plan annoncé.
3. Lecture de langue : trente pages prélevées au hasard, analysées phrase à
   phrase.
4. Lecture de personnages : suivre un secondaire du début à la fin.
5. Lecture de fin : relire les vingt dernières pages, puis les vingt
   premières. La fin répond-elle au début ?

## 5. Contenu du rapport

1. Résumé objectif du livre en dix lignes, sans jugement. S'il est impossible
   à écrire, le livre a un problème de projet.
2. Ce que le livre réussit, avec citations. Trois points au maximum.
3. Ce qui empêche la publication, par ordre de gravité, avec citations.
4. Comparaison éditoriale : à quel rayon appartient ce livre, à côté de quels
   titres, et supporte-t-il la comparaison ?
5. Note pondérée et verdict.
6. Recommandation unique : la seule chose à faire en premier.

## 6. Reproches interdits

- Reprocher le sujet plutôt que son traitement.
- Reprocher à un genre d'être ce genre.
- Reprocher une intention non réalisée sans montrer où elle échoue.
- Substituer ses propres préférences à un jugement de qualité.
- Formuler un reproche sans citation.

## 7. Auto-critique

Axes notés de 0 à 5 : étaiement par citations, hiérarchisation, absence de
préférence personnelle déguisée, netteté du verdict, utilité de la
recommandation unique, respect du projet de l'auteur.

Seuil : aucun axe sous 4.

## 8. Interfaces

- Amont : manuscrit complet, rapport de `story-doctor`.
- Aval : `publication-review`, `rewriting-engine`.
