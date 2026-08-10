---
name: historical-fiction
description: Écrit un roman historique : règle du présent, reconstitution des mentalités, documentation de niveau 3, traitement de la langue sans pastiche, personnages réels, note de l'auteur. À utiliser pour tout récit situé dans le passé et pour traquer les anachronismes.
license: MIT
metadata:
  category: genres
  version: 1.0.0
  depends_on: [writing-constitution, research-director, immersion-director]
  outputs: [dossier-historique, plan-historique, note-de-l-auteur]
---

# Historical Fiction

Le roman historique n'illustre pas le passé : il fait vivre des gens qui
ignorent la suite. Toute la difficulté tient dans ce point.

## 1. Contrat de lecture

Le lecteur exige : une époque tenue, des personnages qui pensent selon leur
temps, une intrigue qui n'est pas dépendante de sa connaissance des faits, et
une honnêteté déclarée sur les libertés prises.

## 2. Règle du présent

Les personnages ne savent pas ce qui va arriver. Ils ne disent jamais qu'ils
vivent une époque charnière. Ils se soucient de la récolte, du loyer, de la
santé d'un enfant, pas de la portée historique des événements.

Corollaire : les grands événements se voient de biais, par leurs effets
locaux, par la rumeur, par le prix du pain.

## 3. Mentalités

- Reconstituer ce qui allait de soi, ce qui était impensable, ce qui était
  scandaleux.
- Ne pas transformer le protagoniste en conscience contemporaine égarée dans
  le passé. Un personnage peut être en avance sur son temps, mais il doit
  alors en payer le prix social, et le lecteur doit voir ce prix.
- La religion, la superstition, l'honneur et la hiérarchie sont des
  motivations réelles, pas des accessoires.
- Les rapports au corps, à la mort, à l'enfance et au temps diffèrent
  profondément et doivent être documentés.

## 4. Documentation

Niveau 3 obligatoire sur : chronologie des faits utilisés, cadre juridique,
monnaie et prix, moyens de transport et durées, hiérarchie sociale, vêtement
et alimentation, techniques du métier représenté.

Le contrôle des anachronismes de `research-director` s'applique à chaque
chapitre, y compris sur le vocabulaire des dialogues.

## 5. Langue

- Ni pastiche archaïsant, ni langue contemporaine. Une langue lisible dont on
  a retiré les mots impossibles.
- Bannir les termes issus de concepts postérieurs : stress, motivation,
  planning, traumatisme, en dehors d'un usage assumé.
- Employer le lexique concret de l'époque pour les objets et les métiers : ce
  sont les noms de choses qui datent un texte, pas la syntaxe.
- Les formes d'adresse et le tutoiement suivent la hiérarchie sociale.

## 6. Personnages historiques réels

- Les faits attestés ne sont pas contredits.
- Les zones d'ombre sont le terrain de la fiction.
- Aucune calomnie inventée sur une personne réelle, aucune attribution de
  crime non documenté.
- Les libertés prises sont déclarées dans la note de l'auteur.

## 7. Clichés à retourner ou proscrire

- La femme moderne avant l'heure, sans conséquence sociale.
- Le personnage qui explique le contexte historique à un autre qui le connaît.
- Le peuple sale et le noble propre, ou l'inverse mécanique.
- La bataille racontée du point de vue du stratège plutôt que du combattant.
- Le personnage qui rencontre toutes les célébrités de son époque.

## 8. Contrôles de sortie

- Aucune anticipation des faits par un personnage.
- Checklist anachronismes passée sur chaque chapitre.
- Les grands événements sont vus par leurs effets locaux.
- La note de l'auteur liste les libertés prises.
- Le vocabulaire des dialogues est contrôlé mot à mot sur les scènes clés.

## 9. Auto-critique

Onze axes de la constitution, plus quatre axes de genre : exactitude
documentaire, justesse des mentalités, tenue de la langue, honnêteté du
paratexte.

Seuil : aucun axe sous 4 sur exactitude documentaire et mentalités.

## 10. Interfaces

- Amont : `research-director`, `immersion-director`.
- Voisins : `genres/political-fiction`, `genres/adventure`.
