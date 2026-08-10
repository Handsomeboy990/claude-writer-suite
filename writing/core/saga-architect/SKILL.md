---
name: saga-architect
description: Conduit une oeuvre en plusieurs tomes : question de tome et question de saga, formes de série, courbe d'ensemble, registre inter-tomes, dettes narratives, rappels au lecteur, mortalité et relève. À utiliser pour planifier une saga ou lancer un tome suivant.
license: MIT
metadata:
  category: core
  version: 1.0.0
  depends_on: [writing-constitution, novel-architect, continuity-manager]
  outputs: [bible-de-saga, plan-multi-tomes, registre-inter-tomes]
---

# Saga Architect

Conception et conduite d'oeuvres longues en plusieurs tomes. Une saga n'est
pas un roman étiré : c'est une architecture à deux niveaux, où chaque tome est
complet et où l'ensemble raconte autre chose que la somme des tomes.

## 1. Loi des deux niveaux

- Niveau tome : question dramatique propre, posée au début, résolue à la fin.
- Niveau saga : question globale, ouverte au tome 1, résolue au dernier tome.

Un tome qui ne résout rien frustre. Un tome qui résout tout referme la saga.
Le bon équilibre : résoudre la question du tome, déplacer la question de la
saga.

## 2. Architecture de série

### 2.1 Formes possibles

| Forme | Principe | Risque |
|---|---|---|
| Cumulative | chaque tome élargit l'enjeu | inflation, surenchère |
| Cyclique | même structure, contexte renouvelé | répétition perçue |
| Générationnelle | changement de protagoniste par tome | perte d'attachement |
| Chorale | plusieurs lignes, convergence finale | dispersion |
| Enquête longue | une question, révélations échelonnées | essoufflement |

Le choix est déclaré dans la bible de saga et ne change pas.

### 2.2 Courbe d'ensemble

Sur cinq tomes, distribution éprouvée :

- Tome 1 : établir le monde, le protagoniste, la question de saga. Fin
  satisfaisante et fissurée.
- Tome 2 : élargir, complexifier, révéler que la victoire du tome 1 était
  partielle. Fin la plus sombre de la série.
- Tome 3 : point médian de la saga, renversement d'information majeur, coût
  humain élevé.
- Tome 4 : conséquences, dispersion des personnages, préparation.
- Tome 5 : convergence, paiement de toutes les dettes narratives.

## 3. Gestion de la mémoire longue

### 3.1 Registre inter-tomes

Extension du registre de `continuity-manager` avec une colonne de tome.
Obligatoire dès le tome 2. Aucun élément d'un tome antérieur ne peut être
réutilisé sans relecture de son entrée d'origine.

### 3.2 Dettes narratives

Toute promesse ouverte est inscrite avec le tome d'ouverture et le tome de
paiement prévu. Une dette non payée à la fin de la saga est un échec, même si
le reste est excellent.

### 3.3 Rappels au lecteur

Un lecteur qui a attendu deux ans entre deux tomes a tout oublié. Techniques
de rappel acceptables :

- réintroduire un personnage par une action caractéristique, pas par un
  résumé ;
- faire réapparaître un objet, ce qui réactive la mémoire épisodique ;
- faire répéter une information par un personnage qui a intérêt à la
  déformer ;
- placer un rappel dans un conflit, jamais dans une explication.

Interdit : le prologue récapitulatif, le personnage qui raconte le tome
précédent, la note de l'auteur.

## 4. Personnages sur la durée

- Un protagoniste ne peut pas parcourir cinq arcs complets. Prévoir un arc de
  saga découpé en étapes, une par tome.
- Prévoir la mortalité : une saga sans perte irréversible perd sa gravité.
- Prévoir la relève : les personnages secondaires du tome 1 deviennent les
  porteurs du tome 3.
- Faire vieillir : un enfant du tome 1 doit avoir grandi de façon cohérente.

## 5. Renouvellement

Chaque tome doit apporter un élément neuf de nature, pas de degré :

- un nouveau lieu structurant ;
- un nouveau rapport de force ;
- une nouvelle règle du monde révélée ;
- un changement de forme narrative maîtrisé.

L'inflation d'enjeux, plus grand ennemi, plus grande armée, plus grand
danger, est interdite comme seul moteur.

## 6. Contrôle avant lancement du tome suivant

- [ ] Question du tome précédent résolue.
- [ ] Question de saga déplacée, non résolue.
- [ ] Registre inter-tomes à jour.
- [ ] Dettes narratives listées et datées.
- [ ] Âges recalculés.
- [ ] Éléments neufs identifiés.
- [ ] Personnages morts, définitivement morts.

## 7. Auto-critique

Axes notés de 0 à 5 : autonomie du tome, progression de la question de saga,
tenue de la mémoire longue, qualité des rappels, évolution des personnages,
renouvellement, absence d'inflation, paiement des dettes.

Seuil : aucun axe sous 3, moyenne minimale 4 à partir du tome 3.

## 8. Interfaces

- Amont : `novel-architect`.
- Latéral : `continuity-manager`, `timeline-manager`.
- Contrôle : `quality/story-doctor`, `quality/publication-review`.
