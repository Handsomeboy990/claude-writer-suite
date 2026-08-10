# Système de skills d'ingénierie

Documentation technique de `engineering/dev-skills`, la couche de pratique du
code.

Deux couches la complètent, documentées dans `delivery-system.md` :
`engineering/delivery-skills` conduit un projet de la spécification à la
livraison, et `engineering/devops-skills` gouverne l'exécution du système. Ce
document couvre la question : comment une modification est faite correctement.

## 1. Objet

Permettre à un agent d'intervenir sur une base de code de production comme un
ingénieur expérimenté : lire avant d'écrire, vérifier avant d'affirmer,
terminer la tranche verticale entière et non la partie qui se démontre bien.

Le système est agnostique de la pile technique. Aucun skill ne présuppose un
framework, une base de données, un mécanisme d'authentification ou une
arborescence. Chaque skill lit le projet qu'on lui confie.

## 2. Langue

Le contenu de `engineering/dev-skills` est rédigé en anglais, contrairement au
reste du repository. Ces skills produisent du code, des messages de commit,
des noms de branche, des pull requests et de la documentation technique, en
anglais
par la règle 6 de `engineering-core`. Rédiger les instructions dans la langue
de leur production supprime une traduction permanente et une source d'erreurs.

Les règles 1 et 2 de la constitution d'écriture continuent de s'appliquer à
tous les fichiers : aucun emoji, aucun tiret cadratin.

## 3. Les vingt skills

### Fondation

| Skill | Responsabilité |
|---|---|
| `engineering-core` | huit lois, règle de preuve, vocabulaire de certitude, définition du terminé |
| `project-exploration` | transforme un repository inconnu en faits vérifiés |
| `engineering-orchestrator` | classe la tâche, compose le plan, impose les portes |

### Conception

| Skill | Responsabilité |
|---|---|
| `architecture-design` | la plus petite architecture qui serve le produit |
| `ui-ux-engineering` | l'expérience rendue, spécifiée avant d'être codée |
| `dependency-selection` | ajouter, remplacer, mettre à jour ou refuser une bibliothèque |

### Implémentation

| Skill | Responsabilité |
|---|---|
| `frontend-engineering` | fonctionnalités client, cinq états, accessibilité |
| `backend-engineering` | handlers, services, données, transactions, jobs |
| `fullstack-engineering` | la tranche verticale et le contrat partagé |

### Vérification

| Skill | Responsabilité |
|---|---|
| `input-validation` | toute valeur externe, validée à la frontière de confiance |
| `security-audit` | balayage en vingt-quatre points, corrections et actions manuelles |
| `debugging` | cause racine avec fichier, ligne et mécanisme |
| `testing-quality` | la bonne couche, dix cas obligatoires, des tests qui peuvent échouer |
| `playwright-automation` | parcours navigateur, preuve responsive et clavier |
| `performance-engineering` | mesurer, corriger le coût dominant, prouver l'écart |
| `code-review-protocol` | cinq passes, puis corriger et vérifier |

### Livraison

| Skill | Responsabilité |
|---|---|
| `technical-documentation` | une documentation conforme à l'implémentation |
| `project-continuity` | une reprise possible par la session suivante |
| `git-workflow` | identité, commits atomiques, hygiène de l'historique |
| `release-readiness` | neuf portes et un verdict de mise en production |

## 4. Chaîne d'exécution

```
requête  ->  engineering-core
         ->  engineering-orchestrator
              classification, localisation de la surface
         ->  project-exploration
              établissement des faits
         ->  skills sélectionnés, dans l'ordre
         ->  portes obligatoires
         ->  verdict de complétude
```

`engineering-core` se charge en premier et n'est jamais recopié par les
autres. L'orchestrateur compose le plan minimal complet : une correction de
faute de frappe fait quatre étapes, un endpoint de paiement en fait onze. Les
deux sont corrects.

## 5. Portes obligatoires

Jamais abandonnées pour gagner du temps.

| Porte | S'applique quand |
|---|---|
| exploration avant décision | du code non lu est touché |
| validation avant persistance | une entrée externe atteint le stockage ou un effet |
| autorisation avant exposition | une route ou une requête renvoie des données d'un utilisateur |
| revue de sécurité avant fusion | auth, paiements, uploads, contenu utilisateur, permissions, secrets, dépendances |
| test avant terminé | tout changement de comportement |
| revue avant livraison | tout code écrit par l'agent |
| continuité avant passation | toute session ayant modifié le repository |
| contrôle d'auteur avant commit | chaque commit |

Une porte peut être satisfaite par une preuve plutôt que par l'exécution
complète d'un skill. Un test existant, exécuté, rouge avant et vert après,
satisfait la porte de test.

## 6. Catégories de tâches

Vingt catégories de classification, chacune dotée d'un plan canonique dans
`engineering/dev-skills/engineering-orchestrator/resources/execution-plans.md` :

EXPLORATION, ARCHITECTURE, FRONTEND, BACKEND, FULLSTACK, DATABASE, API,
AUTHENTICATION, SECURITY, VALIDATION, DEBUGGING, PERFORMANCE, UI_UX, TESTING,
BROWSER_AUTOMATION, DOCUMENTATION, GIT, RELEASE, REFACTORING, DEPENDENCY.

Le format des plans est lisible par machine, ce qui permet à
`tests/validate-orchestration.sh` de vérifier leur cohérence.

## 7. Graphe de dépendances

```
engineering-core
      |
      +-- project-exploration
      |         |
      |         +-- engineering-orchestrator
      |         |
      |         +-- architecture-design --+
      |         +-- ui-ux-engineering ----+
      |         +-- dependency-selection -+
      |                                   |
      |                    +--------------+
      |                    |
      |         backend-engineering   frontend-engineering
      |                    |                 |
      |                    +-- fullstack-engineering
      |                                |
      +-- input-validation ------------+
      |                                |
      +-- security-audit               |
      +-- debugging                    |
      +-- testing-quality -------------+
      |         |                      |
      |         +-- playwright-automation
      |                                |
      +-- performance-engineering -----+
                                       |
                     code-review-protocol
                                |
      technical-documentation <--+--> project-continuity
                                |
                          git-workflow
                                |
                        release-readiness
```

## 8. Validation

```
bash tests/validate-structure.sh      structure et métadonnées des 83 skills
bash tests/validate-rules.sh          règles de la constitution
bash tests/validate-orchestration.sh  plans, références et scénarios
```

Le troisième script couvre les trois catégories d'ingénierie et les agents. Il
vérifie que chaque catégorie de tâche possède un plan, que chaque étape
désigne un skill existant, que les portes obligatoires figurent là où elles
sont
exigées, que l'ordre interne des plans est cohérent, qu'aucun skill n'est
orphelin, que les `depends_on` et les références croisées existent, et que les
cinq scénarios de routage de référence sont respectés.

Il couvre également les quatorze phases de livraison et les quatorze
définitions d'agents. Le détail des douze contrôles figure dans
`delivery-system.md` section 10.

Ces scénarios sont :

| Scénario | Catégorie | Sous-séquence vérifiée |
|---|---|---|
| A, bug dans une API | DEBUGGING | exploration, debugging, backend, tests, revue |
| B, nouvelle page | FRONTEND | exploration, UI/UX, frontend, validation, tests, playwright, performance, revue |
| C, endpoint de paiement | BACKEND | exploration, architecture, backend, validation, sécurité, tests, revue |
| D, revue d'authentification | SECURITY | exploration, sécurité, revue, documentation, avec tests présents |
| E, fonctionnalité complète | FULLSTACK | les douze étapes de la tranche verticale |

## 9. Extension

Ajouter un skill d'ingénierie suppose :

1. créer le dossier dans `engineering/dev-skills/` avec ses quatre éléments
   obligatoires ;
2. déclarer `category: dev-skills` dans le bloc de métadonnées ;
3. renvoyer à `engineering-core` sans le recopier ;
4. inclure une section `Protocol` numérotée, une section `Auto-critique` et
   une section `Interfaces` ;
5. l'ajouter au moins à un plan d'exécution, faute de quoi il est signalé
   comme orphelin ;
6. mettre à jour `engineering/dev-skills/README.md` et ce fichier ;
7. exécuter les trois scripts de validation.
