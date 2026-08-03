---
name: rewriting-engine
category: quality
version: 1.0.0
depends_on: [writing-constitution, self-critique-protocol]
outputs: [version-reecrite, journal-de-reecriture]
---

# Rewriting Engine

Réécriture méthodique d'un texte existant. La réécriture n'est pas la
correction : elle refait, à partir de l'intention, ce que la correction ne
peut pas sauver.

## 1. Décider : corriger ou réécrire

| Situation | Décision |
|---|---|
| Défauts de surface, structure saine | corriger, via `literary-editor` |
| Objectif de scène absent ou faux | réécrire la scène |
| Voix du personnage instable | réécrire les dialogues |
| Trois cycles d'auto-critique sans atteindre le seuil | réécrire depuis la fiche |
| Le texte est bon mais ne sert pas le chapitre | réécrire depuis la fonction |

Règle : on ne réécrit jamais en regardant l'ancienne version. On écrit à
partir de la fiche, puis on compare, puis on récupère les meilleures phrases.

## 2. Les six modes de réécriture

### Mode 1 : réécriture de fonction
La scène est correcte mais ne remplit pas la fonction assignée par le
chapitre. Repartir de la fiche de scène, changer l'objectif, garder le lieu.

### Mode 2 : réécriture de point de vue
Même scène, autre personnage. Révèle immédiatement ce que la scène cachait.
Souvent utilisé pour les scènes de confrontation qui tournent à vide.

### Mode 3 : réécriture par contraction
Réduire de moitié sans rien perdre d'essentiel. Exercice de vérité : ce qui
survit à la contraction est le texte réel.

### Mode 4 : réécriture par expansion
Un passage résumé devient une scène. Réservé aux moments où une valeur
bascule et où le résumé a volé l'émotion au lecteur.

### Mode 5 : réécriture de registre
Même contenu, autre distance narrative ou autre temps. Utilisé quand une
scène est juste mais froide, ou juste mais bavarde.

### Mode 6 : réécriture par suppression
Supprimer la scène et vérifier ce qui manque en aval. Si rien ne manque, la
suppression est définitive. Environ une scène sur dix ne survit pas à ce test.

## 3. Protocole

1. Établir le diagnostic, issu de `self-critique-protocol` ou `story-doctor`.
2. Choisir un mode, un seul.
3. Reformuler l'intention de la scène en une phrase.
4. Écrire la nouvelle version sans consulter l'ancienne.
5. Comparer les deux versions ligne à ligne.
6. Récupérer de l'ancienne version uniquement ce qui est meilleur, et le
   justifier.
7. Passer la nouvelle version au protocole d'auto-critique.
8. Consigner dans le journal de réécriture.

## 4. Récupération

Une phrase de l'ancienne version n'est conservée que si elle satisfait deux
conditions : elle est meilleure que son équivalent neuf, et elle ne tire pas
le nouveau texte vers l'ancien rythme. La deuxième condition élimine la
majorité des candidates.

## 5. Réécriture globale

Pour un manuscrit entier :

- Ne jamais réécrire linéairement du chapitre 1 au dernier. Traiter d'abord
  les chapitres de bascule, puis les chapitres qui les préparent.
- Fixer une règle de style unique par passe : par exemple, cette passe ne
  traite que les fins de chapitre.
- Conserver toutes les versions, numérotées. Ne jamais écraser.
- Arrêter quand deux passes consécutives n'améliorent plus la note globale.
  L'acharnement dégrade.

## 6. Signes d'une réécriture ratée

- Le texte est plus correct et moins vivant.
- Les phrases sont plus courtes mais toutes identiques.
- Les particularités de la voix ont disparu.
- Le texte a gagné en clarté et perdu son mystère.
- L'auteur ne reconnaît plus son texte.

Dans ces cas, revenir à la version antérieure et changer de mode.

## 7. Auto-critique

Axes notés de 0 à 5 : pertinence du mode choisi, gain réel, préservation de
la voix, absence de sur-correction, qualité de la récupération, traçabilité.

Seuil : aucun axe sous 3, moyenne minimale 4 sur préservation de la voix et
gain réel.

## 8. Interfaces

- Amont : `self-critique-protocol`, `story-doctor`, `literary-critic`.
- Aval : `literary-editor`, `proofreader`.
