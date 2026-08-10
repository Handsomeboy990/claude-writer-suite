# Continuity, 2026-08-10

État de reprise du repository. Rédigé selon
`dev-skills/project-continuity/resources/continuity-template.md`.

## Completed

- `dev-skills/`, 20 skills d'ingénierie logicielle, chacun avec `SKILL.md`,
  `README.md`, un exemple travaillé et au moins une ressource.
- `dev-skills/README.md`, index, chaîne d'exécution, portes obligatoires.
- `dev-skills/engineering-orchestrator/resources/execution-plans.md`, un plan
  lisible par machine pour chacune des vingt catégories de tâches.
- `tests/validate-orchestration.sh`, neuf contrôles de cohérence du système.
- `tests/validate-structure.sh`, étendu à la catégorie `dev-skills`, avec deux
  contrôles supplémentaires qui ne s'appliquent qu'à elle.
- `tests/validate-rules.sh`, contrôle 3 corrigé pour ignorer les blocs de code.
- `install.sh`, portées `--writing` et `--dev`.
- `.gitignore`, configuration locale d'agent et fichiers de secrets exclus.
- `documentation/engineering-system.md`, documentation technique du système.
- `CLAUDE.md`, `README.md`, `CONTRIBUTING.md`, `documentation/architecture.md`,
  `documentation/skills-guide.md`, `documentation/README.md`,
  `tests/README.md`, `CHANGELOG.md` mis à jour.

## Current state

Fonctionne aujourd'hui :

- les trois scripts de validation passent, 62 skills contrôlés, 0 erreur ;
- `install.sh` installe 62, 42 ou 20 skills selon la portée, testé dans les
  quatre modes ;
- le système d'ingénierie est cohérent : aucun skill orphelin, aucune
  référence croisée cassée, aucun cycle de dépendances.

Semble terminé et ne l'est pas :

- rien. Les vingt skills sont complets. Ce qui reste ci-dessous relève de
  l'usage et de l'évolution, pas d'une implémentation inachevée.

## Decisions

- `dev-skills` est rédigé en anglais alors que le reste du repository est en
  français. Raison : ces skills produisent du code, des commits et de la
  documentation technique, tous en anglais. Rejeté : traduire les
  instructions en français, ce qui aurait imposé une traduction permanente
  entre l'instruction et sa production. La décision est écrite dans
  `CLAUDE.md` section 4 et `documentation/engineering-system.md` section 2.
- La numérotation `00-` à `19-` proposée pour les dossiers n'a pas été
  reprise. Raison : le repository nomme ses 42 skills existants en kebab-case
  sans préfixe, et un skill est installé sous son nom de dossier dans
  `~/.claude/skills`. Rejeté : imposer une seconde convention de nommage dans
  le même repository.
- `code-review-protocol` plutôt que `code-review`. Raison : les skills sont
  installés à plat dans un répertoire partagé, où `code-review` entre en
  collision avec une commande existante. Le suffixe suit le précédent de
  `quality/self-critique-protocol`.
- Le contrôle `Protocol` et `Interfaces` de `validate-structure.sh` ne
  s'applique qu'à `dev-skills`. Raison : 34 des 42 skills d'écriture nomment
  leur procédure autrement, par héritage de leur domaine. Rejeté : réécrire
  34 skills d'écriture pour satisfaire une convention qui leur est étrangère.
- `CLAUDE.md` reste versionné, contrairement à la règle générale qui exclut
  la configuration d'agent. Raison : c'est la mémoire publique du projet, elle
  ne contient aucun secret, et `tests/validate-structure.sh` exige sa
  présence. `.claude/` est en revanche exclu. La raison est écrite dans
  `.gitignore` et dans `CLAUDE.md` section 6.

## Remaining

- Aucun exemple de projet de démonstration pour `dev-skills`, équivalent de
  `examples/saga-les-cendres-de-kivu/` côté écriture. Premier pas : choisir un
  petit dépôt applicatif réel et y dérouler le scénario E de bout en bout.
- `validate-orchestration.sh` ne vérifie pas que les exemples de chaque skill
  restent cohérents avec son `SKILL.md`. Premier pas : ajouter un contrôle des
  noms de skills cités dans `examples/`.
- Les plans d'exécution ne couvrent pas les tâches d'infrastructure pure,
  conteneurs et pipelines. Premier pas : décider si cela justifie une
  vingt-et-unième catégorie ou une adaptation de RELEASE.

## Risks

- Un skill ajouté à `dev-skills` sans être inscrit dans un plan d'exécution
  est signalé comme orphelin par `validate-orchestration.sh`. Se manifeste
  par un échec du contrôle 6, avec le nom du skill.
- Le contrôle 8 ne reconnaît que les références de la section `Interfaces`.
  Une référence cassée ailleurs dans un `SKILL.md` ne serait pas détectée.
  Sans conséquence aujourd'hui, à revoir si les renvois se multiplient.
- `install.sh` copie les skills à plat dans `~/.claude/skills`. Un nom de
  dossier identique entre les deux systèmes écraserait l'autre. Aucun
  doublon actuellement, vérifié sur les 62 noms.

## Verification

- `bash tests/validate-structure.sh` : 62 skills contrôlés, 0 erreur.
- `bash tests/validate-rules.sh` : 0 erreur, 1 avertissement, sur un exemple
  typographique volontaire de `core/dialogue-master`.
- `bash tests/validate-orchestration.sh` : 0 erreur, neuf contrôles.
- Contrôle négatif : une étape de plan volontairement cassée fait sortir
  `validate-orchestration.sh` en code 1, puis 0 après restauration.
- `bash install.sh` dans les quatre modes : 62, 20, 42 skills installés,
  20 retirés, option inconnue rejetée en code 1.
- `bash -n` sur les quatre scripts shell.
- Graphe de dépendances des 20 skills : acyclique.
- Références de section entre skills et internes : toutes résolues.

## Context

- L'identité Git du repository est imposée et vérifiée :
  `Handsomeboy990 <lauretchacha@gmail.com>`. Aucune signature automatique
  n'est tolérée dans l'historique. La procédure est dans
  `dev-skills/git-workflow`.
- Les deux systèmes du repository ne se croisent pas. Aucun skill d'écriture
  ne dépend d'un skill d'ingénierie, et réciproquement. Cette séparation est
  volontaire et vérifiée : un lecteur qui ajoute une dépendance croisée doit
  d'abord justifier pourquoi.
- Les règles 1 et 2 de la constitution d'écriture, aucun emoji et aucun tiret
  cadratin, s'appliquent à tous les fichiers, y compris `dev-skills`. Le
  contrôle 2 de `validate-rules.sh` couvre aussi le bloc Unicode des flèches,
  de `U+2190` à `U+21FF` : la flèche simple vers la droite est donc refusée,
  et les schémas s'écrivent avec `->`. Ce piège a été rencontré en rédigeant
  ce fichier, et détecté par le script avant le commit.
