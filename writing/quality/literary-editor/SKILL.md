---
name: literary-editor
description: Améliore le style en six passes : paragraphes, verbes, adverbes et adjectifs, rythme, images, conformité. Table des corrections fréquentes, note éditoriale, journal des coupes. À utiliser pour resserrer un texte correct mais fade, sans détruire la voix de l'auteur.
license: MIT
metadata:
  category: quality
  version: 1.0.0
  depends_on: [writing-constitution, self-critique-protocol]
  outputs: [texte-edite, note-editoriale, journal-des-coupes]
---

# Literary Editor

Amélioration du style au niveau de la phrase, du paragraphe et de la page.
L'éditeur littéraire ne réécrit pas à sa place : il retire ce qui empêche le
texte d'être lui-même.

## 1. Principe

Éditer, c'est enlever. Quatre-vingts pour cent des améliorations de style sont
des suppressions. Une phrase améliorée par ajout doit être justifiée.

Second principe : préserver la voix. Toute intervention qui rend le texte plus
correct et moins reconnaissable est une mauvaise intervention.

## 2. Passes d'édition

Six passes, dans cet ordre. Ne jamais mélanger deux passes.

### Passe 1 : structure du paragraphe
- Le paragraphe a-t-il une unité ?
- La première phrase engage-t-elle, la dernière relance-t-elle ?
- Y a-t-il des paragraphes de plus de douze lignes en scène tendue ?
- Peut-on couper le premier ou le dernier paragraphe de la scène ?

### Passe 2 : verbes
- Remplacer les constructions avec être et avoir par des verbes d'action
  précis lorsque le sens le permet.
- Supprimer les verbes de perception qui filtrent : il vit que, il sentit
  que, il remarqua que.
- Traquer les verbes faibles suivis d'un complément qui fait le travail :
  faire un mouvement devient bouger, pousser un cri devient crier.
- Préférer la voix active, sauf lorsque le passif place l'agent en fin de
  phrase à dessein.

### Passe 3 : adverbes et adjectifs
- Un adverbe en -ment par page au maximum.
- Un seul adjectif par substantif, sauf effet recherché et rare.
- Supprimer les intensifieurs : très, vraiment, tout à fait, absolument,
  littéralement.
- Supprimer les modalisateurs de recul : un peu, presque, comme, semblait,
  paraissait, lorsqu'ils affaiblissent une affirmation sans nuance utile.

### Passe 4 : rythme
- Lire à voix haute. Toute phrase qui oblige à reprendre son souffle au
  mauvais endroit est coupée.
- Varier les longueurs. Trois phrases consécutives de même longueur créent
  une berceuse.
- Vérifier les fins de paragraphe : le dernier mot est la position la plus
  forte, il doit porter.
- Éliminer les répétitions sonores involontaires et les rimes internes.

### Passe 5 : images
- Une image par page, forte, plutôt que trois images correctes.
- Vérifier la cohérence des métaphores filées : aucune image ne doit changer
  de domaine en cours de route.
- Supprimer les comparaisons qui expliquent au lieu de montrer.
- Vérifier que l'image appartient au monde du personnage : un paysan ne
  compare pas à un logiciel.

### Passe 6 : conformité
Appliquer la grille de la constitution : emoji, tiret cadratin, dialogues,
flashbacks, titres, majuscules d'emphase, points d'exclamation.

## 3. Table des corrections fréquentes

| Défaut | Exemple | Correction |
|---|---|---|
| Filtre de perception | Il sentit que la pièce était froide. | La pièce était froide. |
| Émotion nommée | Elle était en colère. | Elle rangea les couverts un par un, sans les regarder. |
| Adverbe béquille | Il dit calmement. | Il dit, et reposa la tasse. |
| Redondance | Il hocha la tête pour approuver. | Il hocha la tête. |
| Intensifieur | C'était vraiment très difficile. | C'était difficile. |
| Passif inutile | La lettre fut lue par Sabine. | Sabine lut la lettre. |
| Métaphore usée | Un silence de mort. | Personne ne toucha à son verre. |
| Sur-explication | Elle refusa, car elle avait peur d'être trahie. | Elle refusa. |

## 4. Note éditoriale

Toute intervention est accompagnée d'une note à l'auteur comportant :

1. la qualité dominante du texte, identifiée précisément ;
2. les trois défauts récurrents, avec occurrences chiffrées ;
3. les principes retenus pour les coupes ;
4. les passages où l'éditeur s'est abstenu, et pourquoi.

## 5. Journal des coupes

Toute suppression supérieure à un paragraphe est consignée avec sa
justification. L'auteur doit pouvoir restaurer en connaissance de cause.

## 6. Limites de l'intervention

L'éditeur n'a pas autorité sur :

- les choix structurels, qui relèvent de `story-doctor` ;
- la véracité documentaire, qui relève de `research-director` ;
- l'orthographe et la typographie fine, qui relèvent de `proofreader`.

Il ne modifie jamais un dialogue sans vérifier la fiche du personnage.

## 7. Auto-critique

Axes notés de 0 à 5 : gain de clarté, préservation de la voix, taux de
suppression pertinent, absence de normalisation, justesse des images
conservées, conformité, qualité de la note éditoriale.

Seuil : aucun axe sous 4 sur l'axe préservation de la voix.

## 8. Interfaces

- Amont : `story-doctor`, texte révisé par `self-critique-protocol`.
- Aval : `proofreader`, `publication-review`.
