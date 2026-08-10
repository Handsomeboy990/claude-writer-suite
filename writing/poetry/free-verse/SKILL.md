---
name: free-verse
description: Écrit en vers libres avec rigueur : le vers comme unité de souffle, motivation de chaque coupe, contrainte inventée pour chaque poème, rythme mesuré. À utiliser pour un poème en vers libres, ou pour éviter la prose simplement découpée en lignes.
license: MIT
metadata:
  category: poetry
  version: 1.0.0
  depends_on: [writing-constitution, poet]
  outputs: [poemes-en-vers-libres]
---

# Free Verse

Le vers libre n'est pas l'absence de forme : c'est une forme inventée pour
chaque poème, et tenue avec autant de rigueur qu'une forme fixe.

## 1. Loi fondamentale

Puisque aucune règle extérieure ne soutient le poème, chaque décision doit
être motivée : la longueur du vers, la place de la coupe, le blanc, la
répétition. Un vers libre non motivé est de la prose découpée.

## 2. Le vers comme unité

- Le vers est une unité de souffle et de sens, pas un segment arbitraire.
- La fin de vers est une position forte : le dernier mot est mis en valeur,
  et le lecteur marque une hésitation.
- L'enjambement crée une double lecture : le vers dit une chose, la phrase en
  dit une autre. Cette tension est le principal outil du vers libre.
- Un vers court après plusieurs vers longs produit un choc. L'inverse produit
  une ouverture.

## 3. Structure

Choisir une contrainte propre au poème et la tenir :

- une contrainte de longueur, par exemple aucun vers de plus de sept mots ;
- une contrainte de reprise, un mot ou une structure revenant à intervalles
  réguliers ;
- une contrainte de progression, une image qui se transforme d'une strophe à
  l'autre ;
- une contrainte typographique, blancs, alinéas, colonnes.

La contrainte est notée dans la note prosodique et vérifiée à la relecture.

## 4. Rythme

- Compter les syllabes, même en vers libre : la régularité involontaire
  produit un ronronnement, la variation produit du sens.
- Alterner les groupes rythmiques courts et longs.
- Utiliser les répétitions comme scansion, jamais comme remplissage.
- Éviter la ponctuation lourde : le blanc et la coupe suffisent souvent.

## 5. Pièges

- La prose sentimentale coupée en lignes.
- L'accumulation d'images sans progression.
- L'abstraction majuscule : la Mort, l'Amour, le Temps.
- Le poème qui explique son propre sens dans la dernière strophe.
- Le blanc typographique employé comme substitut d'idée.

## 6. Procédure

1. Écrire la matière en prose, sans retour à la ligne.
2. Identifier le noyau : la phrase qui tient debout seule.
3. Choisir une contrainte de forme.
4. Découper en vers en cherchant, à chaque fin de vers, un mot qui gagne à
   être isolé.
5. Lire à voix haute, ajuster les coupes.
6. Supprimer au moins un tiers.
7. Vérifier que la contrainte est tenue de bout en bout.

## 7. Auto-critique

Axes notés de 0 à 5 : motivation des coupes, tenue de la contrainte, force des
fins de vers, rythme, progression, concrétude, absence de prose découpée.

Seuil : aucun axe sous 3, moyenne minimale 4 sur motivation des coupes.

## 8. Interfaces

- Amont : `poet`.
- Voisins : `poetry/prose-poetry`, `poetry/haiku`.
