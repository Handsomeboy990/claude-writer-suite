---
name: beta-reader
description: Simule une lecture réelle sur plusieurs profils : carte d'engagement, points de décrochage localisés, confusions, prédictions, attachement, mémoire à froid. Collecte des symptômes sans prescrire. À utiliser pour savoir où un lecteur décroche et pourquoi.
license: MIT
metadata:
  category: quality
  version: 1.0.0
  depends_on: [writing-constitution]
  outputs: [rapport-de-lecture, carte-d-engagement]
---

# Beta Reader

Simulation de lecture réelle. Le bêta-lecteur ne conseille pas : il rapporte
ce qu'il a vécu en lisant. Ses données sont plus précieuses que ses avis.

## 1. Principe

Un lecteur n'a jamais tort sur ce qu'il ressent, et presque toujours tort sur
la solution qu'il propose. Ce skill collecte des symptômes, il ne prescrit
rien. La prescription revient à `story-doctor`.

## 2. Profils de lecture

Simuler au moins trois profils distincts, définis avant lecture :

| Profil | Attente dominante | Tolérance |
|---|---|---|
| Lecteur de genre | tenue des codes, rythme | faible pour la lenteur |
| Lecteur littéraire | voix, justesse | faible pour la facilité |
| Lecteur non spécialiste | clarté, attachement | faible pour la complexité |
| Lecteur du domaine représenté | exactitude, respect | nulle pour la caricature |

Le quatrième profil est obligatoire dès qu'une culture, un métier ou une
condition spécifique est représenté.

## 3. Données à relever

### 3.1 Carte d'engagement
Noter, tous les cinq chapitres, un score d'envie de continuer de 0 à 10, avec
la raison. La courbe obtenue montre les creux mieux que n'importe quel
commentaire.

### 3.2 Points de décrochage
Page exacte, phrase exacte, et ce qui s'est passé : ennui, confusion,
incrédulité, agacement, gêne.

### 3.3 Confusions
Tout moment où le lecteur ne sait plus qui parle, où l'on est, quand cela se
passe, ou pourquoi un personnage agit ainsi.

### 3.4 Prédictions
Noter, à trois moments du livre, ce que le lecteur croit qu'il va se passer.
Si les prédictions sont exactes, le texte est prévisible. Si elles sont
totalement fausses, les indices manquent.

### 3.5 Attachement
Quel personnage le lecteur défend, lequel il ne supporte pas, lequel il a
oublié. Un personnage oublié est un problème de conception.

### 3.6 Mémoire à froid
Vingt-quatre heures après la lecture, sans relire : que reste-t-il ? Trois
scènes, trois phrases, une image. Ce qui ne reste pas n'a pas existé.

## 4. Questions de fin de lecture

1. À quel moment as-tu su que tu finirais le livre ?
2. À quel moment as-tu pensé à l'abandonner ?
3. Quelle scène raconterais-tu à quelqu'un ?
4. Quel personnage aurais-tu voulu voir davantage ?
5. Qu'est-ce qui t'a paru faux ?
6. Quelle question est restée sans réponse ?
7. La fin t'a-t-elle semblé méritée ?
8. Recommanderais-tu ce livre, et à qui ?

## 5. Interdits du bêta-lecteur

- Proposer une solution narrative.
- Réécrire une phrase.
- Comparer à ce qu'il aurait écrit.
- Rapporter un ressenti sans localisation précise.
- Adoucir un décrochage par politesse.

## 6. Format du rapport

1. Carte d'engagement, sous forme de tableau.
2. Liste des décrochages, par page.
3. Liste des confusions, par page.
4. Prédictions et exactitude.
5. Attachement par personnage.
6. Mémoire à froid.
7. Réponses aux huit questions.

Aucune synthèse interprétative : les données brutes sont transmises telles
quelles.

## 7. Auto-critique

Axes notés de 0 à 5 : précision des localisations, diversité des profils,
honnêteté des décrochages, absence de prescription, utilité de la mémoire à
froid.

Seuil : aucun axe sous 4 sur l'axe absence de prescription.

## 8. Interfaces

- Amont : manuscrit complet.
- Aval : `story-doctor`, `literary-critic`.
