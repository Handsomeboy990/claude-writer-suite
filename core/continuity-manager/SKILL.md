---
name: continuity-manager
category: core
version: 1.0.0
depends_on: [writing-constitution]
outputs: [registre-de-continuite, rapport-d-incoherences]
---

# Continuity Manager

Maintien de la cohérence globale sur toute la longueur d'un roman ou d'une
saga. Ce skill est un système de mémoire externe, tenu à jour en continu.

## 1. Doctrine

L'incohérence n'est pas une faute d'inattention, c'est une conséquence
mécanique de la longueur. Au-delà de cent mille mots, aucune mémoire humaine
ne suffit. Seul un registre tenu à jour à chaque chapitre garantit la
cohérence.

Règle : le registre est mis à jour immédiatement après la rédaction d'un
chapitre, jamais en fin de manuscrit.

## 2. Les huit registres

### 2.1 Personnages
Nom exact, orthographe, surnoms, âge à chaque date clé, apparence, cicatrices,
langue parlée, métier, statut marital, parents, ce qu'il possède.

### 2.2 Savoir
Qui sait quoi, depuis quel chapitre, et par quel canal. Registre le plus
critique : la majorité des incohérences graves viennent d'un personnage qui
utilise une information qu'il ne peut pas détenir.

### 2.3 Objets
Objets significatifs : où ils se trouvent, qui les détient, leur état. Un
objet perdu au chapitre 12 ne reparaît pas au chapitre 30 sans explication.

### 2.4 Lieux
Distances, durées de trajet, description figée des lieux récurrents, état de
destruction ou de réparation.

### 2.5 Temps
Voir `timeline-manager`. Le registre de continuité ne stocke que les
conséquences : âges, saisons, blessures en cours de guérison, grossesses,
récoltes.

### 2.6 Corps
Blessures, maladies, fatigue, cheveux, vêtements. Une blessure infligée doit
gêner pendant une durée cohérente.

### 2.7 Règles du monde
Toute règle énoncée, même en passant, devient contraignante. Le registre
enregistre la formulation exacte et le chapitre.

### 2.8 Langue et style
Décisions typographiques, orthographe des noms propres, choix de traduction,
système de dialogue retenu, temps de narration.

## 3. Protocole de mise à jour

Après chaque chapitre :

1. Extraire toute affirmation factuelle nouvelle.
2. Vérifier qu'elle ne contredit aucune entrée existante.
3. En cas de contradiction, trancher : corriger le chapitre, ou modifier le
   registre et lister les chapitres à reprendre.
4. Ajouter les nouvelles entrées avec numéro de chapitre.
5. Marquer les promesses ouvertes, à tenir avant la fin.

## 4. Audit complet

À effectuer à la fin de chaque partie et avant toute livraison.

- Passage 1, noms : orthographe, cohérence des surnoms selon les locuteurs.
- Passage 2, âges et dates : recalcul complet.
- Passage 3, savoir : simulation par personnage, chapitre par chapitre.
- Passage 4, objets : suivi de chaque objet nommé plus de deux fois.
- Passage 5, géographie : durées de trajet et distances.
- Passage 6, corps : blessures et guérisons.
- Passage 7, règles : toute règle énoncée est-elle respectée.
- Passage 8, promesses : toute promesse ouverte est-elle tenue ou volontairement
  laissée ouverte pour un tome suivant.

## 5. Classement des incohérences

| Gravité | Définition | Traitement |
|---|---|---|
| Bloquante | rend l'intrigue impossible ou la révélation caduque | correction avant toute autre tâche |
| Majeure | un lecteur attentif la verra et perdra confiance | correction avant livraison |
| Mineure | détail contredit, sans effet sur l'intrigue | correction au passage suivant |
| Assumée | écart volontaire, justifié dans la bible | consigné, non corrigé |

## 6. Cas particulier des sagas

Registre commun à tous les tomes, avec colonne de tome. Voir `saga-architect`.
Toute reprise d'un élément d'un tome antérieur exige la relecture de l'entrée
d'origine, pas du souvenir qu'on en a.

## 7. Auto-critique

Axes notés de 0 à 5 : exhaustivité du registre, fraîcheur de la mise à jour,
détection des contradictions, rigueur du registre de savoir, suivi des objets,
suivi des corps, gestion des promesses, traçabilité des écarts assumés.

Seuil : aucun axe sous 4. La continuité n'admet pas la moyenne.

## 8. Interfaces

- Amont : tous les skills de production.
- Aval : `quality/publication-review`.
