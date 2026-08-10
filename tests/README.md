# tests

Trois scripts sans dépendance externe, exécutables depuis la racine du
repository.

```
bash tests/validate-structure.sh
bash tests/validate-rules.sh
bash tests/validate-orchestration.sh
```

## validate-structure.sh

Vérifie, pour chacun des 83 skills des sept catégories `core`, `genres`,
`poetry`, `quality`, `dev-skills`, `delivery-skills` et `devops-skills` :

- présence de `SKILL.md` et `README.md` ;
- présence et contenu des dossiers `examples/` et `resources/` ;
- bloc de métadonnées YAML complet en tête de `SKILL.md` ;
- correspondance entre les champs `name`, `category` et l'emplacement réel ;
- présence d'une section Auto-critique.

Pour les trois catégories d'ingénierie uniquement, deux contrôles
supplémentaires : présence d'une section `Protocol` numérotée et d'une section
`Interfaces`. Les skills d'écriture nomment leur procédure de façons variées,
héritées de leur domaine, et ne sont pas soumis à cette contrainte.

Vérifie également la présence des fichiers et dossiers racine obligatoires,
dont les six documents attendus dans `documentation/`.

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

Propre aux trois catégories d'ingénierie et aux agents. Douze contrôles :

1. présence des fichiers du système, dont les trois index de catégorie,
   l'orchestrateur, ses plans et le protocole de transmission ;
2. une entrée de classification et exactement un plan par catégorie de tâche ;
3. chaque étape de plan désigne un dossier de skill réel, dans n'importe
   laquelle des trois catégories, et ni `engineering-core` ni
   `engineering-orchestrator` n'apparaissent dans un plan ;
4. portes obligatoires : tout plan commence par `project-exploration`, tout
   plan comportant un skill d'implémentation comporte aussi `testing-quality`,
   `code-review-protocol`, `project-continuity` et `git-workflow` ;
   `ui-ux-engineering` précède `frontend-engineering`, `project-continuity`
   précède `git-workflow`, `release-readiness` termine le plan ;
5. les cinq scénarios de routage de référence, vérifiés comme sous-séquences
   ordonnées des plans concernés ;
6. les quatorze phases de livraison : numérotation séquentielle de 01 à 14,
   skills existants dans chaque phase, portes d'approbation aux phases 02,
   05, 10 et 14 ;
7. aucun skill orphelin, absent de tout plan et de toute phase ;
8. chaque `depends_on` déclaré désigne un skill existant ;
9. chaque référence croisée de la section Interfaces désigne un skill
   existant ;
10. le titre du README de chaque skill correspond au nom du dossier ;
11. les quatorze agents existent, avec un bloc de métadonnées, un `name`
    conforme au fichier, une description suffisante et les huit sections
    obligatoires, et chacun figure dans `agents/README.md` ;
12. chaque skill cité par la section `Skills` d'un agent existe.

Code de sortie 1 en cas d'erreur.

## Intégration

Les trois scripts doivent être exécutés avant tout commit modifiant un skill,
conformément à la section 8 de `CLAUDE.md`. `install.sh` exécute
`validate-structure.sh` avant toute installation.
