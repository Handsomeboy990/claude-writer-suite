# Système de livraison de projet

Documentation technique de `engineering/delivery-skills`,
`engineering/devops-skills` et `engineering/agents`.

## 1. Objet

Prendre un cahier des charges, une spécification, un PRD, une liste de
fonctionnalités ou une demande client, et livrer un système implémenté, testé,
documenté, déployé et vérifié en production.

Le système d'ingénierie précédent, `engineering/dev-skills`, répond à la
question : comment une modification est-elle faite correctement. Ce système
répond à trois autres questions : quoi construire, dans quel ordre et avec
quelle approbation ; comment le système tourne, se déploie et se restaure ; et
qui possède chaque partie du travail.

## 2. Les trois couches

```
delivery-skills   quoi construire, dans quel ordre, avec quelle approbation
dev-skills        comment chaque modification est faite correctement
devops-skills     comment le système tourne, se déploie et se restaure
agents            qui possède quoi, et ce qui est transmis
```

Aucune couche ne recopie le contenu d'une autre. `delivery-orchestrator`
délègue chaque tâche d'implémentation à `engineering-orchestrator` et chaque
tâche opérationnelle à `devops-core`.

## 3. Les quatorze phases

Définies dans
`engineering/delivery-skills/delivery-orchestrator/resources/delivery-phases.md`,
dans un format lisible par machine.

| # | Phase | Porte |
|---|---|---|
| 01 | requirements-analysis | aucune |
| 02 | clarification | approbation |
| 03 | technology-selection | aucune |
| 04 | architecture-proposal | aucune |
| 05 | validation | approbation, arrêt ferme |
| 06 | delivery-planning | aucune |
| 07 | implementation | vérification |
| 08 | integration-verification | vérification |
| 09 | devops | vérification |
| 10 | deployment | approbation |
| 11 | production-verification | vérification |
| 12 | documentation | aucune |
| 13 | handover | aucune |
| 14 | release | approbation |

La profondeur de chaque phase s'adapte au projet. Aucune phase n'est
supprimée sans raison écrite, et la phase 05 ne l'est jamais.

## 4. Les trois sortes de portes

**Approbation.** Le système s'arrête et attend une réponse humaine. Quatre
occurrences : clarification, validation de l'architecture, premier
déploiement, mise en production. Plus toute action irréversible.

**Vérification.** Aucun humain requis, la porte s'ouvre sur des preuves :
intégration exercée, audit de sécurité passé, suite de tests exécutée,
système déployé ayant répondu à une requête réelle.

**Qualité.** Déléguées à la suite d'ingénierie : `code-review-protocol`,
`testing-quality`, `performance-engineering`, `ui-ux-engineering`.

## 5. Les deux règles structurantes

**Aucun code de production avant la porte de validation.** Y compris
l'échafaudage d'un projet. Tout ce qui précède la porte est bon marché à
changer, tout ce qui suit ne l'est pas.

**Aucune demande d'autorisation après.** Une fois l'architecture approuvée, le
système exécute et rend compte aux frontières de phase. Interrompre
l'utilisateur pour un nom de fichier ou une structure de test transforme une
décision réfléchie en un flux de petites décisions, ce que la porte existe
précisément pour éviter.

## 6. delivery-skills, dix skills

| Skill | Responsabilité |
|---|---|
| `delivery-orchestrator` | phases, portes, parallélisation, checklist, verdict |
| `requirements-analysis` | entrée brute vers spécification d'ingénierie |
| `clarification-gate` | ce qui doit être demandé, ce qui peut être supposé |
| `technology-selection` | la pile, avec alternatives et compromis |
| `architecture-proposal` | la proposition en neuf sections, contrat technique |
| `validation-gate` | l'arrêt ferme avant implémentation |
| `delivery-planning` | jalons et tâches atomiques ordonnées |
| `implementation-integrity` | aucune fonctionnalité factice atteignable |
| `scope-and-change-control` | ni dérive de périmètre ni dérive d'architecture |
| `client-handover` | le dossier qu'une autre équipe peut reprendre |

## 7. devops-skills, onze skills

| Skill | Responsabilité |
|---|---|
| `devops-core` | échelle d'environnements, configuration, rayon d'impact |
| `environment-management` | inventaire des variables et contrôles de dérive |
| `secrets-management` | cycle de vie des identifiants, rotation, fuite |
| `containerization` | pertinence d'un conteneur, et construction correcte |
| `ci-cd-pipelines` | un pipeline qui échoue pour les bonnes raisons |
| `deployment-engineering` | mise en service d'un artefact vérifié |
| `database-operations` | migrations, verrous, reprises, sécurité des données |
| `observability` | journaux, santé, métriques, alertes, expurgation |
| `backup-recovery` | une sauvegarde non restaurée est une hypothèse |
| `production-verification` | prouver que le système déployé fonctionne |
| `release-engineering` | versions, étiquettes, changelog, déploiement progressif |

## 8. Les agents

Quatorze rôles, définis dans `engineering/agents/`. Un agent est mince par
construction : l'expertise réside dans les skills, l'agent décide lesquels
s'appliquent, exécute dans sa frontière, et transmet par un artefact durable.

```
                       delivery-orchestrator
                                |
        +---------------+-------+-------+---------------+
        |               |               |               |
   requirements-    software-       security-       devops-
     analyst        architect       engineer        engineer
        |               |               |               |
        +-------+-------+       +-------+-------+       |
                |               |               |       |
          frontend-        backend-        database-    |
          engineer         engineer        engineer     |
                |               |               |       |
          ui-ux-           performance-    playwright-  |
          engineer         engineer        engineer     |
                |               |               |       |
                +-------+-------+-------+-------+-------+
                        |
                   qa-engineer
                        |
              documentation-engineer
                        |
                 release-engineer
```

Les lignes sont des chemins de transmission, pas une hiérarchie de
commandement. Chaque agent rend compte à l'orchestrateur, qui tient les
portes.

### Portes de revue

Aucun agent n'est seul juge de son propre travail critique.

```
frontend-engineer   -> qa-engineer, ui-ux-engineer, revue de code
backend-engineer    -> security-engineer, qa-engineer, revue de code
database-engineer   -> backend-engineer, performance-engineer, release-engineer
devops-engineer     -> security-engineer, release-engineer
security-engineer   -> qa-engineer, pour les tests encodant chaque correction
```

### Transmission

Chaque agent termine par le bloc de
`engineering/agents/handoff-protocol.md` : Completed, Changed, Decisions,
Verified, Known issues, Next action, For. Rien d'important ne circule
uniquement par le contexte conversationnel, car l'agent suivant peut démarrer
sans aucun contexte.

### Emplacement et installation

Les définitions vivent dans `engineering/agents/`, versionnées, et non dans
`.claude/agents/`, parce que `.claude/` est une configuration locale de machine
qui n'est jamais versionnée. L'installeur les copie à l'emplacement attendu
par le runtime.

```
bash install.sh --agents      copie les agents dans ~/.claude/agents
bash install.sh               skills et agents ensemble
bash install.sh --no-agents   skills seulement
```

## 9. Parallélisation

Le travail parallèle exige un contrat défini entre les parties parallèles.

| Sûr | Pourquoi |
|---|---|
| frontend et backend après fixation du contrat d'API | le contrat est le point de synchronisation |
| plusieurs modules de fonctionnalité indépendants | aucun fichier ni schéma partagé |
| documentation d'une zone stabilisée et implémentation ailleurs | l'une lit, l'autre écrit ailleurs |

| Risqué | Pourquoi |
|---|---|
| frontend avant l'existence du contrat de données | l'interface encode une supposition |
| deux tâches touchant la même migration | l'ordre est indéfini |
| une fonctionnalité et le remaniement du module qu'elle utilise | conflit garanti |
| audit de sécurité d'un code encore en cours d'écriture | la cible bouge |

Règle : paralléliser à travers un contrat, jamais à travers un inconnu.

## 10. Validation

```
bash tests/validate-structure.sh      structure et métadonnées des 83 skills
bash tests/validate-rules.sh          règles de la constitution
bash tests/validate-orchestration.sh  douze contrôles de cohérence
```

Le troisième script couvre désormais :

1. présence des fichiers du système, dont les trois index de catégorie et le
   protocole de transmission ;
2. une classification et un plan par catégorie de tâche ;
3. chaque étape de plan désigne un skill réel, quelle que soit sa catégorie ;
4. portes obligatoires et ordre interne des plans ;
5. les cinq scénarios de routage de référence ;
6. les quatorze phases de livraison : numérotation séquentielle, skills
   existants, portes d'approbation aux phases 02, 05, 10 et 14 ;
7. aucun skill orphelin, absent de tout plan et de toute phase ;
8. chaque `depends_on` désigne un skill existant ;
9. chaque référence croisée de la section Interfaces existe ;
10. le titre du README de chaque skill correspond au dossier ;
11. les quatorze agents existent, avec leurs métadonnées et leurs huit
    sections obligatoires ;
12. chaque skill cité par un agent existe.

## 11. Extension

Ajouter un skill de livraison ou d'exploitation suppose :

1. créer le dossier dans `engineering/delivery-skills/` ou
   `engineering/devops-skills/` avec ses quatre éléments obligatoires ;
2. déclarer la catégorie correspondante dans les métadonnées ;
3. renvoyer à sa constitution sans la recopier : `engineering-core` pour tous,
   `devops-core` en plus pour l'exploitation ;
4. inclure une section `Protocol` numérotée, une section `Auto-critique` et
   une section `Interfaces` ;
5. l'inscrire dans au moins un plan d'exécution ou une phase de livraison,
   faute de quoi il est signalé comme orphelin ;
6. mettre à jour l'index de sa catégorie et ce fichier ;
7. exécuter les trois scripts de validation.

Ajouter un agent suppose : le fichier dans `engineering/agents/`, les huit
sections obligatoires, une entrée dans `engineering/agents/README.md`, et
l'ajout de son nom à la liste attendue de
`tests/validate-orchestration.sh`.
