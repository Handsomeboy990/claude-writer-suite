# tests

Trois scripts sans dépendance externe, exécutables depuis la racine du
repository.

```
bash tests/validate-structure.sh
bash tests/validate-rules.sh
bash tests/validate-orchestration.sh
```

## validate-structure.sh

Vérifie, pour chacun des 62 skills des cinq catégories `core`, `genres`,
`poetry`, `quality` et `dev-skills` :

- présence de `SKILL.md` et `README.md` ;
- présence et contenu des dossiers `examples/` et `resources/` ;
- bloc de métadonnées YAML complet en tête de `SKILL.md` ;
- correspondance entre les champs `name`, `category` et l'emplacement réel ;
- présence d'une section Auto-critique.

Pour la catégorie `dev-skills` uniquement, deux contrôles supplémentaires :
présence d'une section `Protocol` numérotée et d'une section `Interfaces`.
Les skills d'écriture nomment leur procédure de façons variées, héritées de
leur domaine, et ne sont pas soumis à cette contrainte.

Vérifie également la présence des fichiers et dossiers racine obligatoires.

Code de sortie 1 en cas d'erreur.

## validate-rules.sh

Applique les interdits de la constitution à tous les fichiers Markdown :

- erreur bloquante en cas de tiret cadratin ;
- erreur bloquante en cas d'emoji ou de pictogramme ;
- avertissement pour les guillemets droits hors exemples ;
- avertissement pour les points d'exclamation multiples hors exemples.

Le contrôle des guillemets droits ignore les blocs de code délimités, où le
guillemet droit est une syntaxe et non une faute de typographie. Les blocs
imbriqués sont gérés par la longueur du délimiteur, comme en Markdown.

Les dossiers `examples/` sont exclus de certains contrôles, car ils
contiennent volontairement des contre-exemples destinés à être corrigés.

## validate-orchestration.sh

Propre au système `dev-skills`. Neuf contrôles :

1. présence des fichiers du système, dont l'orchestrateur et ses plans ;
2. une entrée de classification et exactement un plan par catégorie de tâche ;
3. chaque étape de plan désigne un dossier de skill réel, et ni
   `engineering-core` ni `engineering-orchestrator` n'apparaissent dans un
   plan ;
4. portes obligatoires : tout plan commence par `project-exploration`, tout
   plan comportant un skill d'implémentation comporte aussi `testing-quality`,
   `code-review-protocol`, `project-continuity` et `git-workflow` ;
   `ui-ux-engineering` précède `frontend-engineering`, `project-continuity`
   précède `git-workflow`, `release-readiness` termine le plan ;
5. les cinq scénarios de routage de référence, vérifiés comme sous-séquences
   ordonnées des plans concernés ;
6. aucun skill orphelin, absent de tout plan ;
7. chaque `depends_on` déclaré désigne un skill existant ;
8. chaque référence croisée de la section Interfaces désigne un skill
   existant ;
9. le titre du README de chaque skill correspond au nom du dossier.

Code de sortie 1 en cas d'erreur.

## Intégration

Les trois scripts doivent être exécutés avant tout commit modifiant un skill,
conformément à la section 8 de `CLAUDE.md`. `install.sh` exécute
`validate-structure.sh` avant toute installation.
