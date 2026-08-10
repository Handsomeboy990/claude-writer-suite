# Changelog

Toutes les modifications notables du projet sont consignées ici.
Le format suit une numérotation sémantique.

## 1.2.0

Extension du système d'ingénierie en système complet de livraison de projet.
La suite d'écriture est inchangée.

### Ajouté

- `delivery-skills/` : 10 skills de conduite de projet, de la spécification à
  la livraison, rédigés en anglais.
  - `delivery-orchestrator` : quatorze phases, portes d'approbation et de
    vérification, parallélisation, checklist de livraison, verdict.
  - `requirements-analysis`, `clarification-gate` : compréhension.
  - `technology-selection`, `architecture-proposal`, `validation-gate` :
    décision et approbation.
  - `delivery-planning`, `implementation-integrity`,
    `scope-and-change-control` : exécution.
  - `client-handover` : dossier de reprise.
- `devops-skills/` : 11 skills d'exploitation, agnostiques de la plateforme.
  - `devops-core`, `environment-management`, `secrets-management` : fondation.
  - `containerization`, `ci-cd-pipelines`, `deployment-engineering`,
    `database-operations` : construction et mise en service.
  - `observability`, `backup-recovery`, `production-verification`,
    `release-engineering` : exploitation.
- `agents/` : 14 définitions d'agents spécialisés et le protocole de
  transmission. Un agent cite des skills, il n'en recopie aucun.
- `delivery-skills/delivery-orchestrator/resources/delivery-phases.md` : les
  quatorze phases dans un format lisible par machine, avec leurs portes.
- `documentation/delivery-system.md` : documentation technique des trois
  nouveaux ensembles.
- Index de catégorie : `delivery-skills/README.md`, `devops-skills/README.md`,
  `agents/README.md`.

### Modifié

- `tests/validate-structure.sh` : couvre les sept catégories, 83 skills, et
  exige `Protocol` et `Interfaces` dans les trois catégories d'ingénierie.
- `tests/validate-orchestration.sh` : passe de neuf à douze contrôles. Ajoute
  la validation des quatorze phases de livraison, des portes d'approbation aux
  phases 02, 05, 10 et 14, des quatorze définitions d'agents avec leurs huit
  sections obligatoires, et des skills cités par les agents. La résolution des
  skills traverse désormais les trois catégories.
- `install.sh` : installe aussi les agents dans `~/.claude/agents`, avec les
  options `--agents` et `--no-agents`, et `CLAUDE_AGENTS_DIR` comme cible
  configurable. Six modes vérifiés.
- `CLAUDE.md` : trois orchestrateurs et leurs portées, workflow de livraison,
  langue des nouvelles catégories.
- `README.md`, `CONTRIBUTING.md`, `documentation/architecture.md`,
  `documentation/skills-guide.md`, `documentation/README.md`,
  `documentation/engineering-system.md`, `tests/README.md`, `CONTINUITY.md` :
  prise en compte des trois nouveaux ensembles.

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
