---
name: timeline-manager
description: Gère les temporalités : chronologie réelle et chronologie du lecteur, repères, ellipses, flashbacks en italique avec déclencheur et clôture, récits à lignes multiples, durée ressentie. À utiliser pour placer un flashback, vérifier des dates, ou clarifier une chronologie confuse.
license: MIT
metadata:
  category: core
  version: 1.0.0
  depends_on: [writing-constitution, novel-architect]
  outputs: [chronologie-maitresse, chronologie-lecteur, table-des-flashbacks]
---

# Timeline Manager

Gestion des temporalités : chronologie réelle des événements, ordre de
présentation au lecteur, ellipses, flashbacks, récits parallèles.

## 1. Deux chronologies

Toujours tenir deux documents distincts.

1. Chronologie maîtresse : tous les événements dans l'ordre réel, y compris
   ceux antérieurs au récit et ceux qui ne seront jamais racontés.
2. Chronologie lecteur : l'ordre dans lequel l'information arrive.

L'écart entre les deux est la matière même du suspense et de la surprise.
Il doit être choisi, jamais subi.

## 2. Chronologie maîtresse

Colonnes obligatoires : date absolue, date relative, événement, personnages
présents, conséquence durable, chapitre où l'événement est raconté ou évoqué.

Inclure les événements antérieurs qui expliquent les personnages : blessures
fondatrices, dettes, morts, départs. Ils ne seront pas tous écrits, mais ils
datent les cicatrices.

## 3. Repères pour le lecteur

Le lecteur doit pouvoir répondre à trois questions à tout moment : quand,
depuis combien de temps, dans quel ordre.

Techniques de repérage, du plus lourd au plus léger :

1. Mention datée en tête de chapitre. Efficace, mais mécanique si systématique.
2. Repère saisonnier ou météorologique.
3. Repère corporel : barbe, cicatrice, fatigue, grossesse, croissance d'un
   enfant.
4. Repère matériel : provisions, usure, réparations, dettes échues.
5. Repère social : fêtes, marchés, échéances administratives.

Préférer les niveaux 2 à 5. Réserver le niveau 1 aux récits à lignes
multiples.

## 4. Ellipses

- Une ellipse se marque par un blanc typographique ou un changement de section.
- La première phrase après l'ellipse indique la durée écoulée, par un fait et
  non par une formule.
- Ne jamais ellipser un événement qui change la valeur du récit : ce qui
  compte se joue à l'écran.
- Ellipse longue en fin de partie, jamais en milieu de tension.

## 5. Flashbacks

Application stricte de la constitution, section 4.

Protocole en cinq points :

1. Nécessité : le flashback répond à une question que le lecteur se pose
   déjà. Si la question n'est pas posée, le flashback est une digression.
2. Déclencheur diégétique : odeur, objet, phrase, lieu, geste.
3. Marquage : italique intégral, sans exception.
4. Longueur : deux mille signes maximum en italique dans le fil du texte.
   Au-delà, chapitre daté distinct, composé en romain.
5. Retour : la première phrase après le flashback rétablit le présent par un
   élément sensoriel du lieu réel.

Aucun flashback imbriqué. Aucun flashback dans les trois premiers chapitres,
sauf construction fondée sur la mémoire et déclarée dans la bible.

## 6. Récits à lignes multiples

Quand deux ou plusieurs lignes temporelles coexistent :

- Chaque ligne a un marqueur constant : temps verbal, personne, typographie,
  ou lieu.
- L'alternance suit un rythme stable pendant le premier tiers, pour installer
  le pacte de lecture, puis peut se déformer.
- Les deux lignes doivent converger, sinon la structure n'est qu'un montage.
- Le point de convergence est planifié dès le début et consigné.

## 7. Durée ressentie

Le temps de lecture n'est pas le temps raconté. Trois leviers :

- dilatation : détail, ralenti, perception fragmentée, pour les instants
  décisifs ;
- contraction : sommaire, phrase unique, pour des mois sans enjeu ;
- alternance : la dilatation ne produit d'effet qu'après une contraction.

Un climax dilaté sur vingt pages sans contraction préalable devient mou.

## 8. Contrôles

- Recalculer les âges à chaque changement d'année interne.
- Vérifier la compatibilité entre durée de trajet et enchaînement des scènes.
- Vérifier la saison à chaque scène extérieure.
- Vérifier qu'aucune blessure ne guérit trop vite.
- Vérifier que chaque flashback est refermé.

## 9. Auto-critique

Axes notés de 0 à 5 : exactitude de la chronologie maîtresse, lisibilité pour
le lecteur, pertinence des ellipses, nécessité des flashbacks, respect du
marquage, tenue des lignes multiples, gestion de la durée ressentie, absence
de contradiction temporelle.

Seuil : aucun axe sous 4 sur les axes exactitude et marquage.

## 10. Interfaces

- Amont : `novel-architect`.
- Latéral : `chapter-architect`, `continuity-manager`.
- Contrôle : `quality/story-doctor`.
