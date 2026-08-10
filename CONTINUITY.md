# Continuity, 2026-08-11

État de reprise du repository. Rédigé selon
`dev-skills/project-continuity/resources/continuity-template.md`.

## Completed

Session du 2026-08-10, système d'ingénierie :

- `dev-skills/`, 20 skills, chacun avec `SKILL.md`, `README.md`, un exemple et
  au moins une ressource.
- `tests/validate-orchestration.sh`, contrôles de cohérence du système.
- `documentation/engineering-system.md`.

Session du 2026-08-11, système de livraison et d'exploitation :

- `delivery-skills/`, 10 skills de conduite de projet.
- `devops-skills/`, 11 skills d'exploitation.
- `agents/`, 14 définitions d'agents plus `handoff-protocol.md`.
- `delivery-skills/delivery-orchestrator/resources/delivery-phases.md`, les
  quatorze phases en format lisible par machine.
- `documentation/delivery-system.md`.
- Index de catégorie pour les trois nouveaux ensembles.
- `tests/validate-structure.sh` étendu aux sept catégories.
- `tests/validate-orchestration.sh` porté de neuf à douze contrôles.
- `install.sh` : installation des agents, options `--agents` et `--no-agents`.
- `CLAUDE.md`, `README.md`, `CONTRIBUTING.md`, `CHANGELOG.md`,
  `documentation/architecture.md`, `documentation/skills-guide.md`,
  `documentation/README.md`, `documentation/engineering-system.md`,
  `tests/README.md` mis à jour.

## Current state

Fonctionne aujourd'hui :

- les trois scripts de validation passent : 83 skills contrôlés, 0 erreur,
  1 avertissement préexistant ;
- `install.sh` fonctionne dans six modes, tous vérifiés : complet, écriture,
  ingénierie, agents seuls, sans agents, désinstallation ;
- les trois couches sont cohérentes : aucun skill orphelin, aucune référence
  croisée cassée, aucun cycle de dépendances sur 41 skills ;
- les quatorze agents sont validés : métadonnées, huit sections obligatoires,
  skills cités existants.

Semble terminé et ne l'est pas :

- rien. Les 21 nouveaux skills et les 14 agents sont complets. Ce qui suit
  relève de l'usage et de l'évolution.

## Decisions

- Deux nouvelles catégories plutôt qu'une extension de `dev-skills`. Raison :
  les trois couches répondent à des questions différentes, et une catégorie de
  41 skills serait illisible. Rejeté : tout mettre dans `dev-skills`, ce qui
  aurait mélangé la pratique du code et la conduite de projet.
- Les agents vivent dans `agents/` à la racine, pas dans `.claude/agents/`.
  Raison : `.claude/` est une configuration locale de machine, jamais
  versionnée, conformément à la règle du repository. L'installeur les copie
  vers `~/.claude/agents`. Rejeté : versionner `.claude/agents/`, ce qui
  aurait contredit `.gitignore` et la règle d'hygiène.
- Un agent cite des skills, il n'en recopie aucun. Raison : dupliquer le
  contenu produit deux documents qui divergent. Conséquence : les agents sont
  courts et le contrôle 12 vérifie que chaque skill cité existe.
- `release-engineering` séparé de `release-readiness`. Raison : décider s'il
  faut livrer et décider comment la livraison se déroule sont deux
  responsabilités. La frontière est écrite dans les deux skills et dans
  `devops-skills/README.md`. Rejeté : fusionner, ce qui aurait produit un
  skill de deux responsabilités.
- `containerization` plutôt que `docker`. Raison : la question première est de
  savoir si un conteneur est justifié, et le skill ne présuppose pas un outil.
- Le contrôle des sections `Protocol` et `Interfaces` s'applique aux trois
  catégories d'ingénierie et pas aux skills d'écriture, pour la raison déjà
  consignée en 1.1.0 : 34 skills d'écriture nomment leur procédure autrement.

## Remaining

- Aucun projet de démonstration pour le système de livraison, équivalent de
  `examples/saga-les-cendres-de-kivu/`. Premier pas : dérouler les quatorze
  phases sur un petit dépôt applicatif réel et consigner les artefacts.
- `validate-orchestration.sh` ne vérifie pas la cohérence des exemples de
  chaque skill avec son `SKILL.md`. Premier pas : ajouter un contrôle des noms
  de skills cités dans `examples/`.
- Les plans d'exécution de `engineering-orchestrator` ne couvrent pas les
  tâches d'infrastructure pure. Premier pas : décider si cela justifie une
  vingt-et-unième catégorie de tâche ou si `devops-skills` suffit par les
  phases.
- Aucun contrôle automatique ne vérifie que les portes de revue entre agents,
  décrites dans `agents/README.md`, sont respectées à l'exécution. C'est une
  discipline documentée, pas une contrainte outillée.

## Risks

- Un skill ajouté sans être inscrit dans un plan ou une phase est signalé
  orphelin par le contrôle 7. Se manifeste par un échec nommant le skill.
- Un agent ajouté sans être ajouté à la liste attendue du script est signalé
  par le contrôle 11. L'inverse aussi : un nom dans la liste sans fichier.
- Le contrôle 9 ne couvre que la section `Interfaces`. Une référence cassée
  ailleurs dans un `SKILL.md` ne serait pas détectée automatiquement. Un audit
  manuel a été fait cette session et a trouvé quatre renvois ambigus vers les
  sections internes du document d'architecture, tous corrigés.
- `install.sh` copie les skills à plat dans `~/.claude/skills`. Un nom de
  dossier identique entre catégories écraserait l'autre. Aucun doublon
  actuellement, vérifié sur les 83 noms.
- `code-review-protocol` porte un suffixe pour éviter une collision avec une
  commande existante du runtime. Le même risque existe pour tout nouveau nom
  générique.

## Verification

- `bash tests/validate-structure.sh` : 83 skills contrôlés, 0 erreur.
- `bash tests/validate-rules.sh` : 0 erreur, 1 avertissement, sur un exemple
  typographique volontaire de `core/dialogue-master`, préexistant.
- `bash tests/validate-orchestration.sh` : 0 erreur, douze contrôles.
- Contrôles négatifs : suppression des portes d'approbation des phases, sortie
  en code 1 ; suppression d'un agent, sortie en code 1 ; restauration, code 0.
- `bash install.sh` dans six modes : 83, 41, 42, 0 et 83 skills, 14 et 0
  agents, désinstallation complète.
- `bash -n` sur les quatre scripts shell.
- Graphe de dépendances des 41 skills d'ingénierie : acyclique.
- Références de section, internes et croisées : toutes résolues après
  correction de quatre renvois ambigus.
- Aucun bloc de trois lignes dupliqué entre deux `SKILL.md`.

## Context

- L'identité Git est imposée et vérifiée :
  `Handsomeboy990 <lauretchacha@gmail.com>`. Aucune signature automatique
  n'est tolérée dans l'historique.
- Trois orchestrateurs, trois portées, à ne pas confondre :
  `delivery-orchestrator` pour un projet entier, `engineering-orchestrator`
  pour une tâche, `devops-core` pour l'exécution du système.
- Les deux systèmes du repository ne se croisent toujours pas : aucun skill
  d'écriture ne dépend d'un skill d'ingénierie, et réciproquement.
- Le caractère de flèche du bloc Unicode `U+2190` à `U+21FF` est refusé par le
  contrôle 2 de `validate-rules.sh`, au même titre que les emoji. Les schémas
  s'écrivent avec `->`. Le piège a été rencontré à la session précédente.
- La numérotation des phases dans `delivery-phases.md` est lue par le contrôle
  6 avec `10#` pour éviter l'interprétation octale de `08` et `09`. Modifier ce
  fichier suppose de garder le format `phase: NN` sur deux chiffres.
