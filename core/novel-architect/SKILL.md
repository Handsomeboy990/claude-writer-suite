---
name: novel-architect
category: core
version: 1.0.0
depends_on: [writing-constitution]
outputs: [bible-du-roman, plan-general, arc-des-personnages, calendrier-des-revelations]
---

# Novel Architect

Responsable de la construction globale d'un roman : de la prémisse au plan
chapitre par chapitre. Ce skill décide de la forme avant que la moindre ligne
de prose ne soit écrite.

## 1. Quand l'utiliser

- Au démarrage d'un projet long.
- Quand un manuscrit en cours perd sa direction.
- Avant toute décision de restructuration majeure.

## 2. Entrées requises

Si l'une de ces entrées manque, la produire avant d'aller plus loin.

- Prémisse en une phrase.
- Genre et sous-genre visés.
- Longueur cible en signes ou en mots.
- Public visé et niveau d'exigence.
- Ton dominant et modèle de comparaison éditoriale.

## 3. Protocole

### Étape 1 : verrouiller la prémisse

Format imposé : `Quand [élément déclencheur], [protagoniste caractérisé] doit
[objectif concret] sous peine de [conséquence irréversible], mais [obstacle
structurel].`

Une prémisse est valide si elle contient un désir mesurable, une échéance et
un antagonisme non accidentel. Si elle tient sans le protagoniste nommé, elle
est trop générique.

### Étape 2 : établir la promesse de lecture

Écrire les trois promesses faites au lecteur dans les cinquante premières
pages : promesse d'intrigue, promesse émotionnelle, promesse de monde.
Toute fin qui ne solde pas ces trois promesses sera perçue comme une trahison,
quelle que soit sa qualité intrinsèque.

### Étape 3 : formuler la question dramatique

Une seule question, fermée, à laquelle le dernier chapitre répond par oui ou
par non. Exemple : `Nkusu retrouvera-t-il le nom de son père avant que la
concession soit vendue ?` Toutes les sous-intrigues sont ensuite évaluées à
l'aune de cette question.

### Étape 4 : choisir la structure

| Structure | Usage recommandé | Risque principal |
|---|---|---|
| Trois actes | intrigue orientée objectif | milieu mou |
| Quatre parties | thriller, mystère | mécanique visible |
| Kishotenketsu | récit contemplatif, littérature blanche | absence de tension |
| Structure en spirale | saga, retour cyclique des motifs | répétition perçue |
| Récit enchâssé | mémoire, transmission, enquête intime | perte du fil principal |
| Chronologie éclatée | trauma, révélation différée | confusion du lecteur |

Le choix est écrit et justifié dans la bible. Il n'est pas révisable sans
passage par `quality/story-doctor`.

### Étape 5 : poser les points de bascule

Six points obligatoires, situés en pourcentage de la longueur totale :

1. Image d'ouverture et état initial : 0 à 3 pour cent.
2. Élément déclencheur : 8 à 12 pour cent.
3. Franchissement du seuil, le retour devient impossible : 20 à 25 pour cent.
4. Point médian, renversement de l'information ou du rapport de force :
   50 pour cent.
5. Effondrement, le protagoniste perd ce qu'il croyait acquis : 70 à 75 pour cent.
6. Climax et résolution de la question dramatique : 88 à 96 pour cent.

Tout écart supérieur à cinq points de pourcentage doit être justifié par le
genre.

### Étape 6 : construire l'arc du protagoniste

Renseigner les huit champs suivants :

- désir conscient ;
- besoin inconscient ;
- blessure fondatrice ;
- mensonge que le personnage tient pour vrai ;
- preuve du mensonge dans le monde du récit ;
- scène de coût, où le mensonge lui fait perdre quelque chose ;
- scène de choix, où il peut abandonner le mensonge ;
- état final, gagnant ou perdant, mais transformé.

L'arc de l'antagoniste est construit avec les mêmes champs. Un antagoniste
sans besoin propre est un obstacle, pas un personnage.

### Étape 7 : cartographier les sous-intrigues

Trois à cinq sous-intrigues au maximum pour un roman standard. Chacune est
définie par : porteur, objectif, point de contact avec l'intrigue principale,
chapitre de résolution. Une sous-intrigue qui ne modifie jamais l'intrigue
principale est supprimée ou fusionnée.

### Étape 8 : établir le calendrier des révélations

Tableau à quatre colonnes : information, personnage qui la détient, lecteur
informé au chapitre N, personnage informé au chapitre M. Le décalage entre N
et M produit soit du suspense, soit de la surprise. Le choix est délibéré,
jamais subi.

### Étape 9 : découper en chapitres

Produire une ligne par chapitre : numéro, titre provisoire, point de vue,
lieu, date interne, fonction dramatique, valeur d'entrée et valeur de sortie,
révélation éventuelle. Un chapitre dont la valeur d'entrée égale la valeur de
sortie est un chapitre mort.

### Étape 10 : contrôle de densité

Compter les chapitres par acte, la moyenne de scènes par chapitre et le
nombre de retournements. Un acte central qui contient moins d'un retournement
tous les cinq chapitres produira un ventre mou.

## 4. Livrables

- `bible-du-roman.md` : prémisse, promesses, structure, thème, règles internes.
- `plan-general.md` : tableau des chapitres.
- `arcs.md` : arcs du protagoniste, de l'antagoniste et des secondaires.
- `revelations.md` : calendrier des informations.

Les gabarits sont dans `resources/`.

## 5. Erreurs fréquentes

- Confondre l'intrigue et la succession d'événements. Une succession n'est pas
  une intrigue tant qu'aucun événement n'est causé par le précédent.
- Repousser l'élément déclencheur au-delà du chapitre 4.
- Multiplier les points de vue pour compenser un protagoniste faible.
- Écrire un plan si détaillé qu'il ne reste plus de découverte à l'écriture.
- Résoudre le climax par une information que le lecteur n'avait pas.

## 6. Auto-critique

Notation de 0 à 5 sur : clarté de la prémisse, force de la question dramatique,
tenue de la structure, nécessité causale, arc du protagoniste, utilité des
sous-intrigues, gestion des révélations, densité de l'acte central,
originalité, promesse tenue.

Seuil : aucun axe sous 3, moyenne minimale 3,8. En dessous, reprendre à
l'étape concernée avant toute rédaction de prose.

## 7. Interfaces

- Amont : `research-director`, `world-builder`, `character-psychologist`.
- Aval : `timeline-manager`, `chapter-architect`, `saga-architect`.
- Contrôle : `quality/story-doctor`.
