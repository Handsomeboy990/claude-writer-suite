# writing

Suite d'écriture professionnelle. 42 skills en quatre catégories, plus les
ressources partagées et un projet de démonstration complet.

Langue : français. Gouvernée par `core/writing-constitution`.

## Catégories

| Catégorie | Skills | Objet |
|---|---|---|
| [core](core/) | 14 | fondations et production |
| [genres](genres/) | 15 | spécialisations de genre |
| [poetry](poetry/) | 5 | formes poétiques |
| [quality](quality/) | 8 | contrôle et révision |

Chacune possède son index. Commencer par
[core/writing-constitution](core/writing-constitution/), qui domine toute la
suite.

## Ressources partagées

- [resources/](resources/) : typographie française, structures narratives,
  lexiques, gabarits de démarrage et de suivi. Un skill y renvoie, il n'en
  recopie jamais le contenu.
- [examples/](examples/) : `saga-les-cendres-de-kivu`, un projet de
  démonstration complet, de la bible au rapport de validation.

## Workflow recommandé

```
research-director  ->  world-builder  ->  character-psychologist
        ->  novel-architect  ->  timeline-manager
        ->  chapter-architect  ->  scene-builder
        ->  narrator + dialogue-master + immersion-director
        ->  self-critique-protocol
        ->  story-doctor  ->  literary-editor  ->  proofreader
        ->  beta-reader  ->  literary-critic  ->  publication-review
```

Le détail des onze phases figure dans `documentation/workflow.md`.

Règle d'or : aucun texte n'est terminé avant le passage par
`quality/self-critique-protocol`, puis par au moins un skill de révision.

## Chaîne minimale pour un chapitre

```
chapter-architect -> scene-builder -> dialogue-master
    -> self-critique-protocol -> continuity-manager
```

## Règles communes

Non négociables, définies dans `core/writing-constitution/SKILL.md` :

aucun emoji, aucun tiret cadratin, dialogues conformes aux standards des
romans publiés en français, flashbacks en italique et clairement séparés de la
ligne principale, chronologie toujours compréhensible, titres de chapitres
travaillés, personnages cohérents, style naturel, refus des clichés, montrer
plutôt qu'expliquer, priorité à l'émotion incarnée, respect des cultures
représentées, aucune incohérence tolérée.

Les deux premières s'appliquent à tous les fichiers du repository, y compris à
l'arbre `engineering`.

Chaque skill de production se termine par une auto-évaluation en onze axes,
avec seuil de livraison chiffré.

## Choisir un skill

| Situation | Skill à ouvrir |
|---|---|
| Je démarre un projet | `resources/templates/demarrage-de-projet.md`, puis `core/novel-architect` |
| Je ne sais pas comment couper mes chapitres | `core/chapter-architect` |
| Ma scène est plate | `core/scene-builder` |
| Mes dialogues se ressemblent | `core/dialogue-master` |
| Mon milieu de roman n'avance pas | `quality/story-doctor` |
| Je perds le fil des dates | `core/timeline-manager` |
| Je ne sais plus qui sait quoi | `core/continuity-manager` |
| Mon texte est correct mais fade | `quality/literary-editor` |
| Je veux savoir si c'est publiable | `quality/literary-critic` |

La table complète figure dans `documentation/skills-guide.md`.

## Installation

```
bash install.sh --writing     les 42 skills d'écriture seulement
```

## Relation avec l'arbre engineering

Aucune. Aucun skill d'écriture ne dépend d'un skill d'ingénierie, et
réciproquement. Les deux arbres partagent la structure de skill, les tests et
les règles Git, rien d'autre.
