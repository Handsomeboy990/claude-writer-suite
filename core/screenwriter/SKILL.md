---
name: screenwriter
description: Écrit un scénario : pitch, synopsis, traitement, séquencier, continuité dialoguée, format standard, structure long métrage et série, adaptation d'un roman. À utiliser pour écrire ou adapter un scénario, ou convertir de l'intériorité romanesque en action visible.
license: MIT
metadata:
  category: core
  version: 1.0.0
  depends_on: [writing-constitution, scene-builder, dialogue-master]
  outputs: [traitement, sequencier, continuite-dialoguee]
---

# Screenwriter

Écriture scénaristique : long métrage, série, adaptation d'un roman. Le
scénario n'est pas un roman découpé : il ne dispose que de ce qui se voit et
de ce qui s'entend.

## 1. Contrainte fondatrice

Tout ce qui n'est ni visible ni audible n'existe pas. Les pensées, les
souvenirs, les intentions doivent être traduits en actions, en objets, en
regards, en silences.

Test de conversion : prendre un paragraphe de roman, supprimer tout ce qui
relève de l'intériorité, et vérifier ce qu'il reste. Ce reste est le point de
départ de la scène.

## 2. Étapes du travail

1. Pitch : une phrase.
2. Synopsis : deux à cinq pages, au présent, sans dialogue.
3. Traitement : découpage séquence par séquence, au présent, actions
   dominantes, quelques répliques clés.
4. Séquencier : tableau numéroté avec lieu, moment, personnages, objectif,
   conflit, sortie.
5. Continuité dialoguée : le scénario complet.

Ne jamais écrire la continuité dialoguée avant que le séquencier tienne.

## 3. Format

En-tête de scène : nature, lieu, moment.

```
INT. BUREAU DU CHEF DE SECTEUR - JOUR

Un ventilateur brasse de l'air chaud. SABINE, 41 ans, pose un dossier sur le
bureau, de biais.

                    SABINE
          Trois villages. Deux mille personnes.

                    KABEYA
          Vous avez l'ordre de la direction ?
```

Règles :

- Présent de l'indicatif, troisième personne.
- Un personnage est en capitales à sa première apparition seulement.
- Pas d'indication de plan, de mouvement de caméra, sauf nécessité absolue.
- Pas de didascalie psychologique : `il pense à sa mère` est irrecevable.
- Une page équivaut à une minute environ.

## 4. Structure

Long métrage, cent dix pages :

- Séquence d'ouverture, pages 1 à 10 : monde et manque.
- Élément déclencheur, page 12.
- Fin d'acte 1, page 27 : le protagoniste s'engage.
- Point médian, page 55 : renversement.
- Fin d'acte 2, page 85 : tout est perdu.
- Climax, pages 95 à 105.
- Résolution, pages 105 à 110.

Série : ajouter par épisode une question fermée en fin d'épisode et une
question de saison qui reste ouverte. Voir `saga-architect` pour la logique
multi-saisons.

## 5. Scène de scénario

Chaque scène tient sur quatre lignes de préparation : où, qui veut quoi, quel
obstacle, quelle sortie. Une scène de plus de trois pages doit être justifiée.

Techniques d'efficacité :

- entrer sur un objet qui pose la situation ;
- couper la scène sur la réplique qui déséquilibre, pas sur la réponse ;
- laisser la caméra à un personnage qui ne parle pas ;
- utiliser le hors-champ pour ce qui coûterait cher ou serait complaisant.

## 6. Dialogue de scénario

Différences avec le roman :

- pas d'incise, le nom du personnage remplace le verbe de parole ;
- répliques plus courtes, quatre lignes maximum ;
- l'oralité est plus marquée, mais reste écrite : on coupe les hésitations
  réelles ;
- le sous-texte est encore plus déterminant, car il n'y a pas de narrateur
  pour compenser.

Les règles de la constitution sur les emoji, le tiret cadratin, les clichés et
les cultures s'appliquent intégralement.

## 7. Adaptation d'un roman

Protocole :

1. Identifier la question dramatique du roman.
2. Lister les scènes qui font avancer cette question. Les autres sautent.
3. Fusionner les personnages redondants.
4. Convertir toute intériorité majeure en action ou en conflit.
5. Déplacer les révélations pour tenir le rythme de la structure.
6. Accepter de perdre le style : il sera remplacé par la mise en scène, le
   cadre et le montage.

## 8. Auto-critique

Axes notés de 0 à 5 : clarté visuelle, absence d'intériorité non traduite,
efficacité des entrées et sorties de scène, structure, rythme des pages,
qualité des dialogues, sous-texte, économie de personnages, format.

Seuil : aucun axe sous 3, moyenne minimale 3,8.

## 9. Interfaces

- Amont : `novel-architect`, `character-psychologist`.
- Latéral : `scene-builder`, `dialogue-master`.
- Contrôle : `quality/story-doctor`.
