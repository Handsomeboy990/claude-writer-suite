---
name: dialogue-master
category: core
version: 1.0.0
depends_on: [writing-constitution]
outputs: [dialogues-conformes, rapport-de-voix]
---

# Dialogue Master

Écriture et validation des dialogues selon les standards de l'édition
française. Ce skill a autorité sur toute réplique produite par la suite.

## 1. Typographie du dialogue

### 1.1 Système principal

Guillemets français en ouverture et en fermeture du dialogue, tiret demi
cadratin en tête de chaque réplique suivante, un alinéa par locuteur.

```
« Tu as vu l'heure ?
– J'ai vu l'heure.
– Et tu es rentré quand même.
– Je suis rentré quand même. »
```

Espaces insécables à l'intérieur des guillemets et avant les signes doubles.

### 1.2 Système allégé

Tirets seuls, sans guillemets. Autorisé, mais tenu sur l'intégralité du
manuscrit. Aucun mélange des deux systèmes.

### 1.3 Interdits

- Guillemets droits ou anglais.
- Tiret cadratin.
- Deux locuteurs dans le même paragraphe.
- Réplique ouverte par une majuscule après une incise qui n'a pas fermé la
  phrase.

## 2. Incises

### 2.1 Forme

Entre virgules, avec inversion du sujet et du verbe.

```
« Je pars demain, dit-elle.
– Demain, répéta-t-il, comme si le mot appartenait à une autre langue.
```

Ponctuation : si la réplique se termine par un point d'interrogation ou
d'exclamation, ces signes remplacent la virgule mais l'incise reste en
minuscule.

```
« Tu pars ? demanda-t-il.
```

### 2.2 Économie

- Verbes neutres dans quatre cas sur cinq : dit, répondit, demanda, reprit,
  ajouta.
- Aucun adverbe de manière accolé au verbe de parole.
- Aucun verbe impossible : on ne sourit pas une phrase, on ne hausse pas une
  réplique.
- Une incise sur trois répliques au plus.

### 2.3 Attribution par l'action

Remplacer l'incise par un geste porteur d'information. Le geste doit modifier
la scène, pas la meubler. Un personnage qui hoche la tête n'apporte rien, un
personnage qui repose sa tasse sans avoir bu apporte tout.

## 3. Construction dramatique du dialogue

### 3.1 Loi fondamentale

Un dialogue est un conflit d'objectifs mené par la parole. Chaque personnage
veut obtenir quelque chose de l'autre. Si les deux veulent la même chose et
sont d'accord, la scène n'a pas lieu d'être écrite.

### 3.2 Techniques

- Esquive : répondre à côté de la question. Trois esquives consécutives créent
  une tension immédiate.
- Retard : différer l'information attendue par une action ou une digression.
- Reprise : reprendre le mot de l'autre pour le retourner.
- Interruption : couper avant la fin, marquée par une suspension.
- Silence : la ligne de narration remplace la réponse. Le silence est une
  réplique.
- Asymétrie : un personnage parle par phrases longues, l'autre par monosyllabes.

### 3.3 Ce qu'il faut couper

Salutations, présentations, confirmations, répétitions de ce que le lecteur
sait, politesses sans enjeu, appels du prénom en début de réplique.

## 4. Différenciation des voix

Sept leviers, à choisir par personnage et à consigner :

1. longueur de phrase ;
2. registre, du soutenu au familier, sans transcription phonétique ;
3. champ lexical professionnel ou social ;
4. rapport à la question : pose des questions ou n'en pose jamais ;
5. rapport au conditionnel et à la politesse ;
6. tic de syntaxe, discret, employé au plus une fois par page ;
7. rythme, sec ou ample.

Test obligatoire : masquer les incises. Si l'attribution devient impossible,
la différenciation a échoué.

## 5. Multilinguisme

- Une phrase en langue étrangère doit être comprise par le contexte immédiat.
- Pas de traduction entre parenthèses.
- Pas d'italique systématique si la langue est celle du milieu représenté :
  l'italique exotise.
- Un personnage qui pense dans une langue et parle dans une autre le montre
  par la syntaxe, pas par des mots isolés.

## 6. Monologue et discours long

Un discours de plus de dix lignes doit être interrompu au moins une fois par
une réaction physique de l'auditoire, un changement de lieu, ou une objection.
Sinon, il devient une tribune et le lecteur décroche.

## 7. Contrôles de sortie

- Typographie conforme.
- Un alinéa par locuteur.
- Verbe de parole neutre majoritaire.
- Aucun adverbe de manière sur verbe de parole.
- Test de voix passé.
- Aucune information transmise uniquement pour le lecteur.
- Chaque réplique modifie l'équilibre de la scène.

## 8. Auto-critique

Axes notés de 0 à 5 : conformité typographique, différenciation des voix,
sous-texte, économie, rythme, crédibilité orale, absence d'exposition,
justesse des incises, tension, mémorabilité d'au moins une réplique.

Seuil : aucun axe sous 3, moyenne minimale 3,8.

## 9. Interfaces

- Amont : `character-psychologist`, `scene-builder`.
- Contrôle : `quality/proofreader`, `quality/literary-editor`.
