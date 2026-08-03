---
name: mystery
category: genres
version: 1.0.0
depends_on: [writing-constitution, novel-architect, timeline-manager]
outputs: [plan-du-mystere, table-des-indices]
---

# Mystery

Le mystère est un contrat d'équité : le lecteur doit pouvoir résoudre, et
échouer de justesse. Toute la construction consiste à donner l'information
sans qu'elle soit vue.

## 1. Contrat de lecture

Le lecteur exige : une question claire, des indices honnêtes, une solution
inattendue mais inévitable rétrospectivement. Il ne pardonne pas la
dissimulation d'un fait connu du narrateur.

## 2. Les deux récits

Un mystère contient toujours deux récits :

1. Le récit de ce qui s'est passé, chronologique, complet, écrit en premier
   et jamais publié.
2. Le récit de la découverte, ordre de lecture, qui expose les traces du
   premier.

Aucune ligne du second n'est écrite avant que le premier soit intégralement
établi, y compris les heures, les motivations et les erreurs du coupable.

## 3. Règles d'équité

- Tout indice nécessaire à la solution est présent dans le texte avant la
  révélation.
- Le coupable apparaît dans le premier tiers.
- Aucune information n'est cachée par le narrateur s'il la détient, sauf
  narration non fiable déclarée.
- Aucun jumeau inconnu, aucune coïncidence salvatrice, aucun poison inventé.
- La solution repose sur des éléments compréhensibles sans expertise.

## 4. Technique des indices

| Type | Fonction | Placement |
|---|---|---|
| Indice vrai | permet la solution | dissimulé dans une liste, ou dans une scène chargée |
| Indice vrai déguisé | paraît insignifiant | donné pendant une action plus intéressante |
| Fausse piste honnête | oriente ailleurs, sans mentir | doit avoir sa propre explication |
| Contre-indice | innocente à tort | résolu avant la fin |
| Indice de confirmation | rassure après la révélation | placé dans le dernier tiers |

Techniques de dissimulation : placer l'indice avant une émotion forte, le
donner par un personnage antipathique, le noyer dans une énumération, le
formuler comme une évidence.

## 5. Structure

- Chapitre 1 : la question. Pas nécessairement un crime.
- Premier tiers : présentation du cercle fermé, tous les suspects vus.
- Point médian : une certitude tombe, la question se déplace.
- Dernier tiers : élimination, resserrement, danger pour l'enquêteur.
- Révélation : reconstitution qui relit des scènes déjà lues.
- Après la révélation : conséquence humaine, jamais une simple arrestation.

## 6. Clichés à retourner ou proscrire

- Le coupable le moins probable choisi pour cette seule raison.
- L'aveu spontané en fin de livre.
- Le témoin qui meurt juste avant de parler.
- Le carnet retrouvé qui contient tout.
- La reconstitution devant tous les suspects réunis, sauf traitement ironique
  assumé.

## 7. Contrôles de sortie

- Relire en cherchant les indices : leur nombre doit être compris entre cinq
  et neuf pour un roman.
- Chaque fausse piste a une explication propre et vérifiable.
- Le lecteur peut reconstituer la chronologie réelle après lecture.
- La solution est énonçable en cinq phrases.

## 8. Auto-critique

Onze axes de la constitution, plus quatre axes de genre : équité, qualité de
la dissimulation, inévitabilité rétrospective, tenue des fausses pistes.

Seuil : aucun axe sous 3, moyenne minimale 4 sur équité et inévitabilité.

## 9. Interfaces

- Amont : `novel-architect`, `timeline-manager`.
- Latéral : `continuity-manager` pour le registre du savoir.
- Voisins : `genres/detective`, `genres/thriller`.
