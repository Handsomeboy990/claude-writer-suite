---
name: proofreader
category: quality
version: 1.0.0
depends_on: [writing-constitution]
outputs: [texte-corrige, releve-de-corrections]
---

# Proofreader

Correction orthographique, grammaticale et typographique. Dernière barrière
avant publication. Le correcteur ne touche ni au style ni à la structure.

## 1. Périmètre

Relève de ce skill :

- orthographe lexicale et grammaticale ;
- accords, conjugaisons, concordance des temps ;
- ponctuation et typographie française ;
- homogénéité des conventions ;
- coquilles, doublons, mots manquants.

Ne relève pas de ce skill : le choix des mots, le rythme, les images, la
structure. Toute suggestion stylistique est transmise à `literary-editor`,
jamais appliquée directement.

## 2. Passes de correction

Cinq passes, une seule catégorie d'erreur par passe. La lecture globale ne
détecte rien : c'est la lecture spécialisée qui trouve.

1. Passe accords : sujet et verbe, participes passés, adjectifs.
2. Passe temps : concordance, passé simple contre imparfait, subjonctif.
3. Passe ponctuation et typographie.
4. Passe homogénéité : noms propres, majuscules, nombres, italiques.
5. Passe lecture inversée : lire les phrases de la fin vers le début, ce qui
   neutralise l'anticipation et révèle les coquilles.

## 3. Typographie française

| Signe | Règle |
|---|---|
| Deux-points, point-virgule, interrogation, exclamation | espace insécable avant |
| Guillemets français | espace insécable à l'intérieur |
| Virgule et point | pas d'espace avant, une espace après |
| Points de suspension | trois points en un seul caractère, collés au mot |
| Parenthèses et crochets | pas d'espace intérieure |
| Pourcentage, unités | espace insécable entre le nombre et le symbole |
| Apostrophe | apostrophe typographique courbe |
| Majuscules accentuées | accentuées, y compris en tête de phrase |

Nombres : en toutes lettres jusqu'à seize, puis en chiffres, sauf dates,
heures, mesures et pages. Les siècles s'écrivent en petites capitales
romaines dans l'édition, à défaut en chiffres romains.

Italiques : titres d'oeuvres, mots étrangers non intégrés, flashbacks selon la
constitution. Jamais pour l'emphase.

## 4. Pièges fréquents du français romanesque

- Participe passé avec avoir et complément d'objet direct antéposé.
- Accord du participe passé des verbes pronominaux.
- Concordance après un verbe au passé simple : imparfait, plus-que-parfait.
- Emploi du passé simple à la première personne, correct mais à surveiller.
- Confusions : quelque et quel que, quoique et quoi que, davantage et
  d'avantage, plus tôt et plutôt.
- Ellipses du sujet en enchaînement de propositions.
- Traits d'union des nombres et des impératifs pronominaux.

## 5. Homogénéité

Tenir un relevé unique pour tout le manuscrit :

- orthographe exacte des noms propres et lieux ;
- majuscules des institutions et des titres ;
- écriture des heures et des dates ;
- termes du lexique du monde ;
- système de dialogue retenu ;
- traitement des langues étrangères.

Ce relevé est partagé avec `continuity-manager`.

## 6. Contrôles de conformité constitution

- [ ] Aucun emoji.
- [ ] Aucun tiret cadratin, y compris dans les tableaux et les titres.
- [ ] Tirets de dialogue en demi-cadratin.
- [ ] Guillemets français uniquement.
- [ ] Aucune majuscule d'emphase.
- [ ] Points d'exclamation comptés, un par page maximum.
- [ ] Italiques réservés aux usages autorisés.

## 7. Relevé de corrections

Chaque correction est consignée : page, forme initiale, forme corrigée,
règle appliquée. Les cas douteux sont signalés à l'auteur, non tranchés
d'autorité.

## 8. Auto-critique

Axes notés de 0 à 5 : exhaustivité, exactitude des règles invoquées,
homogénéité, respect du périmètre, signalement des cas douteux, absence de
correction stylistique non demandée.

Seuil : aucun axe sous 4. Une correction fausse est plus grave qu'une
correction manquée.

## 9. Interfaces

- Amont : `literary-editor`.
- Aval : `publication-review`.
