---
name: detective
description: Écrit un roman d'enquête : choix de l'école, construction de l'enquêteur, progression en neuf étapes, vérité de métier et procédure, technique de l'interrogatoire. À utiliser pour un polar, un procédural ou un roman noir.
license: MIT
metadata:
  category: genres
  version: 1.0.0
  depends_on: [writing-constitution, mystery, character-psychologist]
  outputs: [dossier-d-enquete, procedure]
---

# Detective

Roman d'enquête centré sur l'enquêteur. Là où le mystère organise l'énigme, le
roman policier organise une méthode, un milieu et un regard.

## 1. Contrat de lecture

Le lecteur exige : un enquêteur dont la méthode se comprend, un milieu
documenté, une progression par le travail, une vérité qui coûte à celui qui la
trouve.

## 2. Choix de l'école

| École | Moteur | Ce que le lecteur vient chercher |
|---|---|---|
| Énigme classique | déduction pure | le plaisir du puzzle |
| Procédural | méthode collective, institution | l'exactitude du métier |
| Hard boiled | corruption du milieu | la voix et le désenchantement |
| Roman noir | déterminisme social | la fatalité, pas la solution |
| Enquête intime | secret de famille | la vérité qui détruit |

Le choix commande le rythme, la voix et la fin. Il est déclaré dans la bible.

## 3. L'enquêteur

Cinq champs obligatoires en plus de la fiche personnage standard :

1. Méthode : ce qu'il regarde en premier sur une scène.
2. Angle mort : ce qu'il ne voit jamais, et qui coûte au moins une erreur.
3. Autorité : de quel droit il enquête, et ce qui peut le lui retirer.
4. Prix personnel : ce que l'enquête lui prend.
5. Rapport à la loi : ce qu'il est prêt à enfreindre, et où il s'arrête.

L'enquêteur doit se tromper au moins deux fois, dont une fois gravement.

## 4. Progression de l'enquête

Étapes canoniques, à adapter :

1. Découverte et premières constatations.
2. Cercle des intéressés, mobiles apparents.
3. Première hypothèse, cohérente et fausse.
4. Élément qui ruine l'hypothèse.
5. Résistance du milieu : quelqu'un empêche l'enquête.
6. Deuxième hypothèse, partiellement vraie.
7. Danger direct pour l'enquêteur ou pour un tiers.
8. Vérité, obtenue par un détail antérieur relu.
9. Conséquence, souvent injuste.

## 5. Procédure et vérité de métier

- Documenter le cadre légal réel : garde à vue, réquisition, autopsie,
  compétence territoriale, hiérarchie.
- Montrer la lenteur administrative, qui est une source de tension gratuite.
- Le laboratoire n'est ni instantané ni infaillible.
- Les témoins mentent par intérêt, par pudeur, par mémoire défaillante, plus
  souvent que par culpabilité.
- Un interrogatoire est une scène de conflit d'objectifs, pas un questionnaire.

## 6. Interrogatoire, technique

- Fixer ce que chacun veut obtenir et ce que chacun veut cacher.
- Établir qui a le pouvoir dans la pièce, et le faire basculer une fois.
- Utiliser le silence, la répétition d'une question, le retour sur un détail
  matériel.
- L'aveu, s'il vient, arrive par lassitude ou par vanité, jamais par
  démonstration.

## 7. Clichés à retourner ou proscrire

- L'enquêteur alcoolique divorcé sans autre trait.
- Le supérieur qui retire l'affaire sans motif crédible.
- Le médecin légiste qui donne l'heure de la mort à la minute.
- Le tueur en série génial qui laisse des énigmes.
- L'informateur qui sait tout.

## 8. Contrôles de sortie

- La méthode de l'enquêteur est visible dans au moins cinq scènes.
- Chaque avancée résulte d'un acte, jamais d'une confidence gratuite.
- Le milieu est documenté au niveau 2 minimum.
- La vérité a un coût pour l'enquêteur.

## 9. Auto-critique

Onze axes de la constitution, plus quatre axes de genre : lisibilité de la
méthode, exactitude procédurale, qualité des interrogatoires, coût de la
vérité.

Seuil : aucun axe sous 3, moyenne minimale 4 sur exactitude procédurale.

## 10. Interfaces

- Amont : `mystery`, `research-director`.
- Voisins : `genres/thriller`, `genres/political-fiction`.
