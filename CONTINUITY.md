# Continuity, 2026-08-11

État de reprise du repository. Rédigé selon
`engineering/dev-skills/project-continuity/resources/continuity-template.md`.

## Completed

Session 1, système d'ingénierie :

- 20 skills `dev-skills`, chacun avec `SKILL.md`, `README.md`, un exemple et
  au moins une ressource.
- `tests/validate-orchestration.sh`.
- `documentation/engineering-system.md`.

Session 2, livraison et exploitation :

- 10 skills `delivery-skills`, 11 skills `devops-skills`.
- 14 agents plus `handoff-protocol.md`.
- `delivery-phases.md`, les quatorze phases en format lisible par machine.
- `documentation/delivery-system.md`.
- Validation portée de neuf à douze contrôles ; installeur étendu aux agents.

Session 3, réorganisation :

- Deux arbres : `writing/` regroupe `core`, `genres`, `poetry`, `quality`,
  `resources`, `examples` ; `engineering/` regroupe `dev-skills`,
  `delivery-skills`, `devops-skills`, `agents`.
- 392 fichiers déplacés par `git mv`, détectés comme renommages purs.
- `README.md` racine réécrit autour des deux arbres.
- Six index créés : `writing/README.md`, `engineering/README.md`, et un par
  catégorie d'écriture. Les quatre catégories d'ingénierie avaient déjà le
  leur.
- `tests/validate-structure.sh` : résolution des catégories par arbre, et
  exigence d'un `README.md` par arbre et par catégorie.
- `tests/validate-orchestration.sh` et `install.sh` : chemins adaptés.
- Chemins préfixés dans tous les documents racine et la documentation.

## Current state

Fonctionne aujourd'hui :

- les trois scripts passent : 83 skills, 0 erreur, 1 avertissement
  préexistant sur un exemple typographique volontaire ;
- `install.sh` fonctionne dans six modes ;
- tous les liens des sept README résolvent ;
- aucune référence de chemin obsolète ne subsiste hors du `CHANGELOG.md`, où
  les entrées historiques décrivent volontairement l'état d'alors.

Semble terminé et ne l'est pas :

- rien. La réorganisation est complète et validée.

## Decisions

- Deux arbres plutôt que deux repositories. Raison : les deux systèmes
  partagent la structure de skill, les tests, l'installeur et les règles Git ;
  les séparer en deux dépôts aurait dupliqué quatre mécanismes pour isoler du
  contenu qui ne se croise déjà pas. Rejeté : un second repository.
- `resources/` et `examples/` passent sous `writing/`. Raison : leur contenu
  est entièrement d'écriture, typographie française et saga de démonstration.
  Rejeté : les laisser à la racine, ce qui aurait laissé croire qu'ils
  servent aussi l'ingénierie.
- `documentation/` et `tests/` restent à la racine. Raison : `architecture.md`
  et `skills-guide.md` couvrent les deux arbres, et les trois scripts valident
  les deux. Rejeté : dupliquer la documentation par arbre.
- Le nom de catégorie reste celui du dossier de skills ; l'arbre n'est qu'un
  préfixe de chemin. Raison : les métadonnées `category:` des 83 skills
  restent valides et aucun fichier de skill n'a été modifié. Rejeté :
  `category: writing/core`, qui aurait imposé 83 modifications.
- Les entrées historiques du `CHANGELOG.md` gardent les chemins d'alors, et la
  réorganisation est décrite dans une entrée 1.3.0. Raison : un changelog
  consigne ce qui s'est passé, il ne se réécrit pas.
- Les décisions des sessions précédentes restent valides : agents versionnés
  dans le dépôt et non dans `.claude/`, contenu de l'ingénierie en anglais,
  `code-review-protocol` suffixé pour éviter une collision de nom.

## Remaining

- Aucun projet de démonstration pour le système de livraison, équivalent de
  `writing/examples/saga-les-cendres-de-kivu/`. Premier pas : dérouler les
  quatorze phases sur un petit dépôt applicatif réel.
- `validate-orchestration.sh` ne vérifie pas la cohérence des exemples de
  chaque skill avec son `SKILL.md`. Premier pas : contrôler les noms de skills
  cités dans `examples/`.
- Les plans d'exécution ne couvrent pas les tâches d'infrastructure pure.
  Premier pas : décider si cela justifie une vingt-et-unième catégorie de
  tâche.
- Aucun contrôle automatique ne vérifie que les portes de revue entre agents
  sont respectées à l'exécution. C'est une discipline documentée.

## Risks

- Un skill ajouté sans être inscrit dans un plan ou une phase est signalé
  orphelin par le contrôle 7.
- Un agent ajouté sans être ajouté à la liste attendue du script est signalé
  par le contrôle 11, et réciproquement.
- Le contrôle 9 ne couvre que la section `Interfaces`. Une référence cassée
  ailleurs dans un `SKILL.md` ne serait pas détectée automatiquement.
- `install.sh` copie les skills à plat dans `~/.claude/skills`. Un nom de
  dossier identique entre deux catégories écraserait l'autre. Aucun doublon
  actuellement, vérifié sur les 83 noms.
- Les renvois internes aux skills restent relatifs à leur arbre : un skill
  d'écriture cite `core/writing-constitution`, un skill d'ingénierie cite
  `dev-skills/engineering-core`. C'est volontaire et cohérent avec
  l'installation à plat. Seuls les documents racine portent le préfixe
  d'arbre.

## Verification

- `bash tests/validate-structure.sh` : 83 skills, 0 erreur.
- `bash tests/validate-rules.sh` : 0 erreur, 1 avertissement préexistant.
- `bash tests/validate-orchestration.sh` : 0 erreur, douze contrôles.
- `bash install.sh` dans six modes, avant et après la réorganisation.
- `bash -n` sur les quatre scripts shell.
- Liens des sept README : tous résolvent.
- `git status` : les 392 déplacements sont des renommages purs, zéro insertion
  et zéro suppression sur le déplacement lui-même.

## Context

- L'identité Git est imposée :
  `Handsomeboy990 <lauretchacha@gmail.com>`. Aucune signature automatique.
- Trois orchestrateurs, trois portées :
  `engineering/delivery-skills/delivery-orchestrator` pour un projet entier,
  `engineering/dev-skills/engineering-orchestrator` pour une tâche,
  `engineering/devops-skills/devops-core` pour l'exécution du système.
- Le bloc Unicode des flèches, `U+2190` à `U+21FF`, est refusé par le contrôle
  2 de `validate-rules.sh` au même titre que les emoji. Les schémas s'écrivent
  avec `->`.
- La numérotation des phases dans `delivery-phases.md` est lue avec `10#` pour
  éviter l'interprétation octale de `08` et `09`. Garder le format
  `phase: NN`.
- Après tout déplacement de dossier, exécuter les trois scripts : deux d'entre
  eux résolvent des chemins et échouent proprement en nommant ce qui manque.
