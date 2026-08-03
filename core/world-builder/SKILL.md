---
name: world-builder
category: core
version: 1.0.0
depends_on: [writing-constitution, research-director]
outputs: [bible-du-monde, regles-internes, cartographie, lexique]
---

# World Builder

Création d'univers cohérents, qu'ils soient inventés, historiques ou
contemporains. Un monde n'est crédible que s'il est contraint.

## 1. Principe directeur

On ne construit pas un monde pour lui-même. On construit ce qui produit du
conflit, ce qui limite les personnages et ce qui sera vu. Tout le reste existe
en arrière-plan, sans être écrit, et se manifeste par des effets.

Règle du dixième : le lecteur voit un dixième du monde construit. Le neuvième
dixième sert uniquement à garantir que le dixième visible ne se contredit pas.

## 2. Ordre de construction

### 1. Contrainte matérielle

Commencer par la ressource rare : eau, terre arable, énergie, métal, sécurité,
information. Toute société s'organise autour de ce qui manque. La rareté
détermine ensuite le pouvoir, le droit, la géographie du peuplement et les
conflits.

### 2. Géographie et climat

Relief, réseaux d'eau, sols, saisons, vents dominants. Puis en déduire :
routes, ports, frontières naturelles, cultures, architecture, vêtement,
rythme de la journée.

### 3. Économie

Qui produit, qui échange, qui prélève. Monnaie ou troc, crédit, dette.
Un monde sans économie visible sonne creux même en fantasy.

### 4. Pouvoir

Source de légitimité : force, naissance, élection, savoir, religion, argent.
Mode de succession. Contre-pouvoirs. Ce qui arrive à celui qui désobéit,
concrètement, avec un exemple daté.

### 5. Croyances

Ce que l'on craint, ce que l'on promet aux morts, ce qui est impur. Les rites
sont des faits sociaux : ils coûtent du temps et de l'argent, ils excluent
et ils rassemblent.

### 6. Savoir et technique

Niveau technique, transmission du savoir, alphabétisation, médecine. Le
niveau technique doit être cohérent avec l'économie et l'énergie disponibles.

### 7. Langue

Voir `resources/lexique.md`. Ne créer que les mots que le récit emploiera.
Cinq à quinze termes suffisent pour donner l'impression d'une langue entière.

## 3. Systèmes spéciaux : magie, technologie, pouvoir surnaturel

Cinq questions obligatoires, sans réponse ferme le système ne tient pas :

1. Qui peut l'utiliser, et pourquoi eux.
2. Quel est le coût, payé immédiatement et visiblement.
3. Quelle est la limite absolue, jamais franchie.
4. Qui contrôle l'accès, et quel pouvoir social cela crée.
5. Pourquoi le monde n'a pas été transformé plus radicalement par son
   existence.

Corollaire : le lecteur doit connaître les règles avant qu'elles ne résolvent
un problème majeur. Une capacité révélée au moment du climax annule la
tension.

## 4. Cohérence en cascade

Toute décision se propage. Vérifier systématiquement les conséquences sur :

- la nourriture et sa conservation ;
- la durée des déplacements ;
- la circulation de l'information ;
- la place des femmes, des enfants et des vieillards ;
- la médecine et la mortalité ;
- le traitement des morts ;
- l'éclairage et le rapport à la nuit.

Ces sept points révèlent quatre-vingt-dix pour cent des incohérences.

## 5. Révélation du monde

- Aucun paragraphe d'encyclopédie. L'information passe par l'usage, le
  conflit, le manque ou l'erreur d'un personnage.
- Un personnage ne remarque pas ce qui lui est familier : le monde se décrit
  par l'oeil de qui arrive, de qui revient, ou de qui perd quelque chose.
- Trois détails précis valent mieux qu'une description exhaustive.
- Le lexique local s'introduit par le contexte, jamais par une glose.

## 6. Mondes réels et historiques

Quand le monde existe, il est documenté par `research-director` et non
inventé. Les règles de représentation de la constitution, section 8,
s'appliquent intégralement. Aucun raccourci, aucune couleur locale
décorative.

## 7. Pièges

- Le monde figé, où rien n'a changé depuis mille ans.
- La carte avant la contrainte.
- L'empire unique sans concurrence ni périphérie.
- Le peuple entier défini par un seul trait.
- Le système magique sans coût, ou dont le coût n'est jamais payé à l'écran.
- La géographie impossible : capitale sans eau, port sans arrière-pays.

## 8. Auto-critique

Axes notés de 0 à 5 : cohérence interne, contrainte matérielle, crédibilité
économique, logique du pouvoir, tenue du système spécial, absence
d'encyclopédisme, richesse sensorielle, originalité, respect culturel,
utilité dramatique.

Seuil : aucun axe sous 3, moyenne minimale 3,8.

## 9. Interfaces

- Amont : `research-director`.
- Latéral : `immersion-director`, `timeline-manager`.
- Contrôle : `continuity-manager`.
