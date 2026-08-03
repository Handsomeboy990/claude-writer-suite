---
name: research-director
description: Dirige la documentation d'un projet : identification des besoins par chapitre, trois niveaux de profondeur, hiérarchie des sources, vérification croisée, traduction en matière narrative, contrôle des anachronismes, sujets sensibles. À utiliser avant d'écrire sur un métier, une époque ou un lieu réel.
license: MIT
metadata:
  category: core
  version: 1.0.0
  depends_on: [writing-constitution]
  outputs: [dossier-documentaire, fiches-sources, notes-de-verification]
---

# Research Director

Direction documentaire du projet. Détermine ce qu'il faut savoir, à quel
niveau de certitude, et comment cette matière entre dans le texte sans
l'alourdir.

## 1. Principe

On ne documente pas un sujet, on documente une scène. La recherche part
toujours d'un besoin narratif précis, sinon elle devient une fuite devant
l'écriture.

Trois niveaux de profondeur :

| Niveau | Usage | Effort |
|---|---|---|
| Niveau 1, ambiance | mentions ponctuelles, arrière-plan | rapide, sources générales |
| Niveau 2, opérationnel | gestes, procédures, vocabulaire de métier | sources spécialisées, témoignages |
| Niveau 3, structurel | l'intrigue dépend de l'exactitude | sources primaires, vérification croisée |

Un roman standard comporte deux à quatre sujets de niveau 3 au maximum.

## 2. Protocole

### Étape 1 : lister les besoins

Parcourir le plan et noter, chapitre par chapitre, toute affirmation
vérifiable : métier, arme, maladie, trajet, monnaie, loi, date, technique,
climat, coutume.

### Étape 2 : classer par niveau

Attribuer un niveau à chaque besoin. Ne pas documenter au niveau 3 ce qui
n'est pas structurel.

### Étape 3 : chercher

Ordre de priorité des sources :

1. sources primaires : archives, textes de loi, rapports, correspondances,
   photographies, cartes d'époque ;
2. témoignages directs et entretiens ;
3. travaux universitaires ;
4. ouvrages de vulgarisation sérieux ;
5. presse contemporaine des faits.

Les sources encyclopédiques en ligne servent d'entrée, jamais de preuve.

### Étape 4 : vérifier

Toute donnée de niveau 3 doit être confirmée par deux sources indépendantes.
Attention particulière aux chiffres, aux dates, aux distances, aux durées de
trajet et aux termes techniques.

### Étape 5 : ficher

Une fiche par sujet, avec les champs du gabarit `resources/fiche-source.md`.
Consigner explicitement la marge d'incertitude et ce qui reste inconnu.

### Étape 6 : traduire en matière narrative

Pour chaque fiche, extraire :

- un geste précis qu'un praticien ferait sans y penser ;
- un mot de métier employé sans être expliqué ;
- une contrainte qui peut faire échouer un personnage ;
- une erreur classique que commet un novice ;
- un détail sensoriel non évident.

C'est ce quintet, et non la fiche, qui entre dans le texte.

### Étape 7 : oublier

Après rédaction, vérifier que moins de dix pour cent de la documentation
apparaît. Si la proportion est plus élevée, le texte est un exposé.

## 3. Anachronismes et vigilance

Points de contrôle systématiques pour un récit situé dans le passé :

- objets du quotidien et leur date d'apparition ;
- vocabulaire et expressions, y compris dans les dialogues ;
- rapports sociaux, statut juridique des personnes ;
- durée réelle des communications et des déplacements ;
- monnaie, prix, salaires ;
- éclairage, chauffage, hygiène, médecine ;
- gestes disparus, comme allumer, se laver, écrire, payer.

## 4. Sujets sensibles

Pour toute représentation d'une culture, d'une religion, d'un handicap, d'une
maladie, d'une violence ou d'un métier à risque :

- privilégier les sources produites par les personnes concernées ;
- distinguer ce qui est documenté de ce qui est supposé ;
- refuser le détail spectaculaire non nécessaire ;
- documenter les conséquences, pas seulement les faits.

## 5. Traçabilité

Le dossier documentaire est versionné avec le manuscrit. Chaque affirmation de
niveau 3 dans le texte renvoie à une fiche. En cas de contestation éditoriale,
la fiche est la réponse.

## 6. Auto-critique

Axes notés de 0 à 5 : pertinence des besoins identifiés, qualité des sources,
vérification croisée, absence d'anachronisme, traduction narrative,
discrétion de la documentation, traitement des sujets sensibles,
traçabilité.

Seuil : aucun axe sous 3, moyenne minimale 3,8. Pour un récit historique,
seuil relevé à 4 sur l'axe anachronisme.

## 7. Interfaces

- Aval : `world-builder`, `immersion-director`, `character-psychologist`.
- Contrôle : `continuity-manager`, `quality/publication-review`.
