# tests

Deux scripts sans dépendance externe, exécutables depuis la racine du
repository.

```
bash tests/validate-structure.sh
bash tests/validate-rules.sh
```

## validate-structure.sh

Vérifie, pour chacun des 42 skills :

- présence de `SKILL.md` et `README.md` ;
- présence et contenu des dossiers `examples/` et `resources/` ;
- bloc de métadonnées YAML complet en tête de `SKILL.md` ;
- correspondance entre les champs `name`, `category` et l'emplacement réel ;
- présence d'une section Auto-critique.

Vérifie également la présence des fichiers et dossiers racine obligatoires.

Code de sortie 1 en cas d'erreur.

## validate-rules.sh

Applique les interdits de la constitution à tous les fichiers Markdown :

- erreur bloquante en cas de tiret cadratin ;
- erreur bloquante en cas d'emoji ou de pictogramme ;
- avertissement pour les guillemets droits hors exemples ;
- avertissement pour les points d'exclamation multiples hors exemples.

Les dossiers `examples/` sont exclus de certains contrôles, car ils
contiennent volontairement des contre-exemples destinés à être corrigés.

## Intégration

Ces deux scripts doivent être exécutés avant tout commit modifiant un skill,
conformément à la section 8 de `CLAUDE.md`.
