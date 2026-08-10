# engineering

Système d'ingénierie logicielle et de livraison de projet. 41 skills en trois
catégories, plus 14 agents spécialisés.

Langue : anglais, pour la raison exposée dans
`documentation/engineering-system.md` section 2. Les règles 1 et 2 de la
constitution d'écriture s'appliquent tout de même : aucun emoji, aucun tiret
cadratin.

## Catégories

| Catégorie | Skills | Question à laquelle elle répond |
|---|---|---|
| [dev-skills](dev-skills/) | 20 | comment une modification est faite correctement |
| [delivery-skills](delivery-skills/) | 10 | quoi construire, dans quel ordre, avec quelle approbation |
| [devops-skills](devops-skills/) | 11 | comment le système tourne, se déploie et se restaure |
| [agents](agents/) | 14 | qui possède quoi, et ce qui est transmis |

Chacune possède son index.

## Les trois constitutions

```
dev-skills/engineering-core     les huit lois, la règle de preuve, le
                                vocabulaire de certitude, la définition du
                                terminé
devops-skills/devops-core       l'échelle d'environnements, la configuration,
                                le rayon d'impact, le protocole destructeur
```

Aucun skill ne recopie sa constitution : il y renvoie. Un agent ne recopie
jamais un skill : il le cite.

## Trois orchestrateurs, trois portées

| Orchestrateur | Possède | Se charge quand |
|---|---|---|
| `delivery-skills/delivery-orchestrator` | un projet entier | l'entrée est une spécification, un cahier des charges, une demande client |
| `dev-skills/engineering-orchestrator` | une tâche | l'entrée est une fonctionnalité, un défaut, une revue |
| `devops-skills/devops-core` | l'exécution du système | toute opération sur un environnement |

Le premier délègue au deuxième pour chaque tâche d'implémentation, et au
troisième pour chaque opération.

## Chaîne d'une tâche

```
engineering-core  ->  engineering-orchestrator  ->  project-exploration
        ->  skills sélectionnés, dans l'ordre
        ->  portes obligatoires
        ->  verdict de complétude
```

L'orchestrateur compose le plan minimal complet : une correction de faute de
frappe fait quatre étapes, un endpoint de paiement en fait onze. Les plans
canoniques sont dans
`dev-skills/engineering-orchestrator/resources/execution-plans.md`.

## Chaîne d'un projet

```
requirements-analysis  ->  clarification-gate          APPROBATION
        ->  technology-selection  ->  architecture-proposal
        ->  validation-gate                            APPROBATION, arrêt ferme
        ->  delivery-planning  ->  implementation
        ->  integration-verification  ->  devops
        ->  deployment                                 APPROBATION
        ->  production-verification  ->  documentation
        ->  handover  ->  release                      APPROBATION
```

Quatorze phases, définies dans
`delivery-skills/delivery-orchestrator/resources/delivery-phases.md`.

Deux règles structurantes : aucun code de production avant la porte de
validation, échafaudage compris ; aucune demande d'autorisation après, pour le
travail inclus dans le périmètre approuvé.

## Portes obligatoires

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

## Ce que le système refuse

Une ligne par catégorie, car ces refus sont ce qui distingue ce système d'un
assistant de code.

```
deviner quoi que ce soit que le repository peut établir
affirmer sans avoir exécuté
laisser une fonctionnalité factice sur un chemin atteignable
écrire du code de production avant l'approbation de l'architecture
affaiblir un test pour obtenir un pipeline vert
coder en dur une valeur qui varie selon l'environnement
exécuter une instruction destructrice sans compter les lignes d'abord
déclarer un déploiement réussi sans avoir exercé un parcours
annoncer des sauvegardes sans dire si une restauration a été testée
```

## Agnosticisme

Aucun skill ne présuppose un framework, une base de données, un mécanisme
d'authentification, une arborescence ou une plateforme d'hébergement. Chaque
skill lit le projet qu'on lui confie.

## Installation

```
bash install.sh --dev         les 41 skills d'ingénierie seulement
bash install.sh --agents      les 14 agents seulement
bash install.sh --no-agents   les skills sans les agents
```

Les skills vont dans `~/.claude/skills`, les agents dans `~/.claude/agents`.

## Documentation

- `documentation/engineering-system.md` : la couche `dev-skills` en détail.
- `documentation/delivery-system.md` : les couches `delivery-skills`,
  `devops-skills` et `agents`.

## Relation avec l'arbre writing

Aucune, hormis les deux interdits typographiques et les règles Git. Aucun
skill d'ingénierie ne dépend d'un skill d'écriture.
