---
name: narrator
category: core
version: 1.0.0
depends_on: [writing-constitution]
outputs: [charte-de-narration, voix-narrative]
---

# Narrator

Gestion de la narration : qui raconte, depuis quand, à quelle distance, avec
quelle mémoire, et ce que cette instance ne peut pas savoir.

## 1. Décisions fondatrices

Quatre décisions sont prises une fois pour toutes et consignées dans la bible.
Toute dérogation ultérieure est un défaut, sauf si elle est systématisée.

1. Personne : première, deuxième, troisième.
2. Focalisation : interne, externe, zéro.
3. Temps : passé simple, passé composé, présent.
4. Distance : le narrateur est-il collé au personnage, à un pas, ou très loin.

## 2. Tableau des choix

| Combinaison | Effet dominant | Coût |
|---|---|---|
| Première personne, présent | immersion maximale, urgence | mémoire du narrateur difficile à justifier |
| Première personne, passé | voix, ironie rétrospective | le narrateur survit, donc le suspense vital baisse |
| Troisième interne, passé simple | standard du roman français | risque de neutralité |
| Troisième interne, présent | tension moderne | fatigue sur la longueur |
| Troisième externe | opacité, effet de caméra | émotion difficile à faire passer |
| Omniscience assumée | ampleur, saga, ironie | perte d'identification si mal tenue |
| Deuxième personne | étrangeté, adresse | insoutenable au-delà de la nouvelle longue |

## 3. Distance narrative

Cinq degrés, du plus lointain au plus proche :

1. Résumé narratif : `Il passa trois ans à Kisangani.`
2. Narration objective : `Il descendit du bus et compta ses billets.`
3. Narration colorée : `Le bus le laissa dans une chaleur qui sentait le
   caoutchouc brûlé.`
4. Discours indirect libre : `Trois ans. Trois ans, et toujours pas de nom sur
   la porte.`
5. Pensée directe : `Je n'aurais pas dû revenir.`

Règle : le passage d'un degré à l'autre doit être progressif à l'intérieur
d'une scène. Sauter du degré 1 au degré 5 sans transition produit une rupture
que le lecteur ressent comme une faute de style.

Le discours indirect libre est l'outil central du roman français : il permet
de rester à la troisième personne tout en donnant le lexique et la syntaxe du
personnage. Il ne prend ni guillemets, ni italiques, ni verbe introducteur.

## 4. Contrat de connaissance

Établir explicitement :

- ce que le narrateur sait dès la première page ;
- ce qu'il apprend en même temps que le lecteur ;
- ce qu'il sait mais ne dira pas encore, et pourquoi ce silence est
  justifiable après coup ;
- ce qu'il ne peut pas savoir.

Un narrateur à focalisation interne ne décrit pas son propre visage, ne
connaît pas les pensées d'autrui, ne rapporte pas une scène à laquelle il
n'assistait pas sans indiquer sa source.

## 5. Narrateur non fiable

Quatre formes utilisables :

- non fiabilité par intérêt : il ment pour se protéger ;
- par incapacité : âge, maladie, ivresse, traumatisme ;
- par valeurs : il juge selon un système que le lecteur ne partage pas ;
- par ignorance : il rapporte fidèlement ce qu'il comprend mal.

Règle de loyauté : tous les éléments permettant au lecteur de reconstruire la
vérité doivent être présents dans le texte avant la révélation. La non
fiabilité est un jeu, pas une tricherie.

## 6. Voix

Une voix narrative se construit sur cinq paramètres mesurables :

1. longueur moyenne de phrase et variance ;
2. lexique dominant, issu du métier ou du milieu du narrateur ;
3. rapport aux images : rares et fortes, ou nombreuses et filées ;
4. rapport au jugement : commente, ou refuse de commenter ;
5. rythme de ponctuation, notamment l'usage des deux-points et du point
   virgule.

Pour tenir une voix sur quatre cents pages, écrire une page témoin et s'y
référer à chaque reprise du manuscrit après interruption.

## 7. Transitions et ellipses

- Une ellipse se signale par un changement de section, un repère temporel dans
  la première phrase, ou une variation d'état du monde.
- Ne jamais résumer ce qui vient d'être montré.
- Le passage d'un point de vue à un autre se fait au blanc typographique,
  jamais en cours de paragraphe.

## 8. Erreurs fréquentes

- Glissement de focalisation : entrer dans la tête d'un second personnage le
  temps d'une phrase.
- Narrateur qui décrit ce qu'il ne peut pas voir.
- Filtres de perception accumulés : il vit, il sentit, il remarqua.
- Voix uniforme entre le narrateur et tous les personnages.
- Commentaire moral du narrateur en fin de scène, qui annule l'effet.

## 9. Auto-critique

Axes notés de 0 à 5 : constance de la personne et du temps, tenue de la
focalisation, justesse de la distance, qualité du discours indirect libre,
respect du contrat de connaissance, singularité de la voix, gestion des
ellipses, absence de commentaire surplombant.

Seuil : aucun axe sous 3, moyenne minimale 3,8.

## 10. Interfaces

- Amont : `novel-architect`.
- Latéral : `scene-builder`, `dialogue-master`.
- Contrôle : `continuity-manager`, `quality/literary-editor`.
