# genres

Genre specialisations. 15 skills. Each inherits `core/writing-constitution` and
adds its own reading contract, codes, prohibitions and self-critique axes.

A genre skill never replaces `core`: it layers on top. Build first with
`novel-architect` and `scene-builder`, then apply the genre.

## The skills

| Skill | Reading contract | Dominant requirement |
|---|---|---|
| [thriller](thriller/) | threat, deadline, acceleration | temporal pressure |
| [mystery](mystery/) | a fair puzzle | fairness of the clues |
| [detective](detective/) | method, milieu, cost of the truth | procedural accuracy |
| [horror](horror/) | loss of safety | economy of showing |
| [fantasy](fantasy/) | a world that holds, a coherent impossible | necessity of the fantastic |
| [dark-fantasy](dark-fantasy/) | a world that does not reward virtue | absence of complacency |
| [science-fiction](science-fiction/) | a hypothesis followed to the end | depth of consequences |
| [cyberpunk](cyberpunk/) | asymmetry of power, body, debt | material density |
| [historical-fiction](historical-fiction/) | a period held, accurate mentalities | documentary accuracy |
| [romance](romance/) | transformation through meeting | strength of the internal obstacle |
| [adventure](adventure/) | territory, attrition, return | consistency of attrition |
| [dystopian](dystopian/) | a system that works | credibility of the system |
| [political-fiction](political-fiction/) | how a decision is manufactured | absence of manicheism |
| [espionage](espionage/) | loyalties and their cost | coherence of the betrayal |
| [magical-realism](magical-realism/) | an unexplained marvellous | non-astonishment held |

## Families and neighbours

Adjacent genres share mechanics and cite each other in their Interfaces
section.

```
Tension            thriller, espionage, detective
Puzzle             mystery, detective
Fear               horror, dark-fantasy
Secondary world    fantasy, dark-fantasy, science-fiction
Near future        science-fiction, cyberpunk, dystopian
Power              political-fiction, dystopian, espionage
Period             historical-fiction, adventure
Feeling            romance, magical-realism
```

A project often crosses two genres. When it does, one carries the dominant
reading contract and the other supplies codes. Deciding which is an
architectural decision, not a matter of taste.

## How many skills to load

One, as a rule. Two when the project is explicitly hybrid. Three is a sign
that the reading promise has not been decided.

## Research

Every genre skill demands proportionate research. For any narrative set in a
real place, trade or period, go through `core/research-director` first.

`historical-fiction` additionally carries the rule of the present and the
anachronism hunt.

## Output

The genre self-critique, then `quality/self-critique-protocol`. Neither
replaces the other: the first checks the reading contract, the second the
general quality.

## Configuration

`language.creative_output` sets the output language for every skill here.
