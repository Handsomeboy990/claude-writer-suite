---
name: thriller
category: genres
version: 1.0.0
depends_on: [writing-constitution, novel-architect, scene-builder]
outputs: [plan-thriller, scenes-de-tension]
---

# Thriller

Le thriller repose sur une seule ressource : le temps qui manque. Tout ce qui
n'augmente pas la pression est supprimé.

## 1. Contrat de lecture

Le lecteur exige : une menace claire, un compte à rebours, un protagoniste
dépassé mais actif, une accélération continue, une résolution qui coûte cher.
Il tolère mal la lenteur, la digression et le hasard favorable.

## 2. Les quatre piliers

1. Enjeu vital, énoncé avant la fin du chapitre 3.
2. Échéance visible, rappelée physiquement, jamais par un compteur abstrait.
3. Antagoniste compétent, en avance d'un coup pendant les deux premiers tiers.
4. Coût croissant : chaque tentative du protagoniste lui retire quelque chose.

## 3. Structure

- Chapitres courts, 1200 à 2500 mots, raccourcissant à mesure que la tension
  monte.
- Fin de chapitre sur un déséquilibre, mais pas systématiquement sur un
  cliffhanger : au-delà d'un chapitre sur trois, l'effet s'annule.
- Point médian : le protagoniste comprend que le problème n'est pas celui
  qu'il croyait.
- Dernier tiers : plus aucune information nouvelle, uniquement des
  conséquences.

## 4. Mécaniques de tension

| Mécanique | Fonctionnement | Erreur à éviter |
|---|---|---|
| Bombe sous la table | le lecteur sait, le personnage ignore | oublier de rappeler la bombe |
| Compte à rebours | échéance concrète et matérielle | échéance repoussée sans coût |
| Piège qui se referme | les issues se ferment une à une | rouvrir une issue par facilité |
| Traque inversée | le chasseur devient gibier | inverser trop tôt |
| Preuve fragile | l'élément qui sauve peut être détruit | le rendre indestructible |
| Allié incertain | le doute sur un proche | trancher le doute trop vite |

## 5. Rythme

- Alterner scènes d'action et scènes de resserrement, jamais deux scènes
  d'action consécutives sans conséquence entre elles.
- La respiration est obligatoire après un pic, jamais avant.
- La description est autorisée uniquement si elle prépare un danger ou une
  fuite.
- Le passé du personnage entre par fragments, jamais par flashback long.

## 6. Clichés à retourner ou proscrire

- Le protagoniste qui ne prévient pas la police sans raison crédible.
- Le méchant qui explique son plan au moment de tuer.
- Le téléphone qui n'a jamais de réseau.
- L'expert qui trouve l'information en trois minutes.
- La famille menacée employée comme seul moteur émotionnel.
- Le retournement final qui annule tout ce qui précède.

## 7. Crédibilité

Chaque procédure technique, policière, médicale ou administrative doit être
documentée par `research-director` au niveau 2 minimum. Un thriller perd son
lecteur sur une invraisemblance de métier plus vite que sur une faiblesse de
style.

## 8. Contrôles de sortie

- L'échéance est rappelée toutes les vingt pages par un fait, pas par une
  phrase.
- Aucune scène ne se termine dans le même état d'équilibre qu'elle a commencé.
- Le protagoniste agit dans au moins soixante pour cent des scènes.
- Aucun sauvetage par hasard.
- La menace se réalise partiellement au moins une fois avant le climax.

## 9. Auto-critique

Onze axes de la constitution, plus quatre axes de genre : pression temporelle,
compétence de l'antagoniste, irréversibilité des pertes, crédibilité
procédurale.

Seuil : aucun axe sous 3, moyenne minimale 4 sur les axes de genre.

## 10. Interfaces

- Amont : `novel-architect`, `research-director`.
- Latéral : `scene-builder`, `timeline-manager`.
- Voisins : `genres/espionage`, `genres/mystery`.
