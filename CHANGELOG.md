# Changelog

Toutes les modifications notables du projet sont consignées ici.
Le format suit une numérotation sémantique.

## 1.1.0

Ajout d'un second système de skills, dédié à l'ingénierie logicielle. La suite
d'écriture est inchangée.

### Ajouté

- `dev-skills/` : 20 skills d'ingénierie logicielle, agnostiques de la pile
  technique, rédigés en anglais.
  - Fondation : `engineering-core`, `project-exploration`,
    `engineering-orchestrator`.
  - Conception : `architecture-design`, `ui-ux-engineering`,
    `dependency-selection`.
  - Implémentation : `frontend-engineering`, `backend-engineering`,
    `fullstack-engineering`.
  - Vérification : `input-validation`, `security-audit`, `debugging`,
    `testing-quality`, `playwright-automation`, `performance-engineering`,
    `code-review-protocol`.
  - Livraison : `technical-documentation`, `project-continuity`,
    `git-workflow`, `release-readiness`.
- `dev-skills/engineering-orchestrator/resources/execution-plans.md` : un plan
  d'exécution lisible par machine pour chacune des vingt catégories de tâches.
- `tests/validate-orchestration.sh` : neuf contrôles de cohérence du système
  d'ingénierie, dont les cinq scénarios de routage de référence.
- `documentation/engineering-system.md` : documentation technique du système.
- `dev-skills/README.md` : index et ordre de lecture.
- `CONTINUITY.md` : état de reprise du repository.

### Modifié

- `tests/validate-structure.sh` : couvre la catégorie `dev-skills` et exige,
  pour elle seule, une section `Protocol` numérotée et une section
  `Interfaces`.
- `tests/validate-rules.sh` : le contrôle des guillemets droits ignore les
  blocs de code délimités, y compris imbriqués. Les avertissements passent de
  trois à un, le dernier étant un exemple typographique volontaire.
- `install.sh` : options de portée `--writing` et `--dev`, combinables avec
  `--zip` et `--remove`. Installation par défaut des 62 skills.
- `.gitignore` : exclusion de la configuration locale d'un agent et des
  fichiers de secrets. `CLAUDE.md` reste versionné, la raison est écrite dans
  le fichier.
- `CLAUDE.md`, `README.md`, `CONTRIBUTING.md`,
  `documentation/architecture.md`, `documentation/skills-guide.md`,
  `documentation/README.md`, `tests/README.md` : prise en compte du second
  système et du troisième script de validation.

## 1.0.0

Version initiale.

### Ajouté

- `CLAUDE.md` : mémoire du projet, règles permanentes, conventions, workflow,
  règles Git, philosophie.
- `core/writing-constitution` : document fondateur, interdits typographiques,
  conventions de dialogue françaises, traitement des flashbacks, style,
  personnages, cultures, seuils d'auto-critique.
- 13 autres skills `core` : novel-architect, chapter-architect, scene-builder,
  narrator, dialogue-master, character-psychologist, world-builder,
  immersion-director, research-director, continuity-manager, timeline-manager,
  saga-architect, screenwriter.
- 15 skills `genres` : thriller, mystery, detective, horror, fantasy,
  dark-fantasy, science-fiction, cyberpunk, historical-fiction, romance,
  adventure, dystopian, political-fiction, espionage, magical-realism.
- 5 skills `poetry` : poet, sonnet, haiku, free-verse, prose-poetry.
- 8 skills `quality` : self-critique-protocol, story-doctor, literary-editor,
  literary-critic, proofreader, beta-reader, rewriting-engine,
  publication-review.
- `resources/` : typographie française, catalogue de structures narratives,
  lexiques, gabarits de démarrage et de suivi.
- `examples/saga-les-cendres-de-kivu/` : projet de démonstration complet, de
  la bible au rapport de validation.
- `documentation/` : architecture, guide des skills, règles d'écriture,
  workflow.
- `tests/` : validation de structure et validation des règles de la
  constitution.
