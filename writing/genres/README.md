# genres

Spécialisations de genre. 15 skills. Chacun hérite de
`core/writing-constitution` et ajoute un contrat de lecture, des codes, des
interdits et des axes d'auto-critique propres.

Un skill de genre ne remplace jamais `core` : il s'y superpose. On construit
d'abord avec `novel-architect` et `scene-builder`, puis on applique le genre.

## Les skills

| Skill | Contrat de lecture | Exigence dominante |
|---|---|---|
| [thriller](thriller/) | menace, échéance, accélération | pression temporelle |
| [mystery](mystery/) | énigme équitable | équité des indices |
| [detective](detective/) | méthode, milieu, coût de la vérité | exactitude procédurale |
| [horror](horror/) | perte de sécurité | économie de la monstration |
| [fantasy](fantasy/) | monde tenu, impossible cohérent | nécessité du fantastique |
| [dark-fantasy](dark-fantasy/) | monde qui ne récompense pas la vertu | absence de complaisance |
| [science-fiction](science-fiction/) | hypothèse menée jusqu'au bout | profondeur des conséquences |
| [cyberpunk](cyberpunk/) | asymétrie de pouvoir, corps, dette | densité matérielle |
| [historical-fiction](historical-fiction/) | époque tenue, mentalités justes | exactitude documentaire |
| [romance](romance/) | transformation par la rencontre | force de l'obstacle interne |
| [adventure](adventure/) | territoire, attrition, retour | cohérence de l'attrition |
| [dystopian](dystopian/) | système qui fonctionne | crédibilité du système |
| [political-fiction](political-fiction/) | fabrique de la décision | absence de manichéisme |
| [espionage](espionage/) | loyautés et leur coût | cohérence de la trahison |
| [magical-realism](magical-realism/) | merveilleux non expliqué | tenue du non-étonnement |

## Familles et voisinages

Les genres proches partagent des mécaniques et se citent mutuellement dans
leur section Interfaces.

```
Tension            thriller, espionage, detective
Énigme             mystery, detective
Peur               horror, dark-fantasy
Monde secondaire   fantasy, dark-fantasy, science-fiction
Anticipation       science-fiction, cyberpunk, dystopian
Pouvoir            political-fiction, dystopian, espionage
Époque             historical-fiction, adventure
Sentiment          romance, magical-realism
```

Un projet croise souvent deux genres. Dans ce cas, un seul porte le contrat de
lecture dominant, l'autre fournit des codes. Choisir lequel est une décision
d'architecture, pas de goût.

## Combien de skills charger

Un, en principe. Deux quand le projet est explicitement hybride. Trois est le
signe que la promesse de lecture n'a pas été décidée.

## Documentation associée

Chaque skill de genre exige une documentation proportionnée. Pour tout récit
situé dans un lieu réel, un métier réel ou une époque réelle, passer d'abord
par `core/research-director`.

`historical-fiction` porte en plus la règle du présent et la traque des
anachronismes.

## Sortie

Auto-critique du genre, puis `quality/self-critique-protocol`. Les deux ne se
remplacent pas : le premier vérifie le contrat de lecture, le second la
qualité générale.
