# A formal request, with its gaps marked

The instruction, in full:

> Write to the town hall to get a copy of our building permit. They rejected
> our last request. Make it formal, cite the law that says they have to give
> it to us.

The last clause is the one that matters, and it is the one that must be
refused as stated.

## What section 1 refuses

The instruction asks for a legal citation. Nobody supplied the text of a law.
Producing a plausible article number would be the single most damaging thing
this skill can do: it would be quoted in a formal letter to a public
administration, and the administration would be the one to discover it was
wrong.

Three options existed. Only the third is available.

| Option | Verdict |
|---|---|
| Write a plausible article reference | forbidden; automatic failure under section 9 |
| Write a vague appeal to a right of access | weak, and still an unverified legal assertion |
| Draft the letter without the citation, and mark it | correct |

The right of access to administrative documents does exist in France. Which
text governs it, which article, and which version applies to this request is
not something to reconstruct from memory into a document that will be filed.
It is marked for the user, with the exact information needed to fill it.

## Elements gathered

| Element | Status |
|---|---|
| Sender identity and address | provided |
| Recipient | *the town hall*; department not identified. Gap. |
| Permit reference | provided, PC-2024-0871 |
| Date of the previous request | provided, 3 June 2026 |
| How the previous request was sent | not provided. Gap, and it matters. |
| Reason given for the rejection | not provided. Gap, and it matters most. |
| Legal basis | not provided. Gap, marked for the user. |

Three gaps that change the letter, asked in one batch per `project-brief`:

```
1. [required] What reason did they give for refusing? A letter answering the
   actual reason is a different letter from one that ignores it.
2. [required] How was the 3 June request sent: counter, post, registered post,
   online form? Proof of the earlier request changes the second one.
3. [required] For the legal basis, send me the reference you rely on, or say
   you have none. I will not write an article number I have not read.
```

## The draft, delivered with its gaps visible

```
Marie Rousseau                          Mairie de Villeneuve
14 rue des Tilleuls                     [TO VERIFY: exact department, likely
69100 Villeneuve                        Service urbanisme; check the town hall
marie.rousseau@example.org              website or ask at the counter]
06 12 34 56 78                          Place de la Republique
                                        69100 Villeneuve

Vos references : [TO PROVIDE: reference on their refusal, if any]
Nos references : PC-2024-0871

                                        Villeneuve, le 11 aout 2026

Objet : Seconde demande de copie du permis de construire PC-2024-0871
Piece jointe : 1. Copie de la demande du 3 juin 2026

Madame, Monsieur,

Je sollicite la delivrance d'une copie du permis de construire PC-2024-0871,
delivre le [TO PROVIDE: date on the permit] pour le bien situe [TO PROVIDE:
address of the property].

Une premiere demande a ete adressee a vos services le 3 juin 2026 [TO PROVIDE:
how it was sent; if by registered post, add the tracking number here, it is
the strongest element of this letter]. Cette demande n'a pas abouti [TO
PROVIDE: state the reason given for the refusal here, factually, without
comment].

[TO CONFIRM: legal basis for the request. The right of access to
administrative documents exists in French law, but I will not write an article
number I have not read. Send me the reference you rely on, or ask the
Commission d'acces aux documents administratifs, and I will insert it here.
Leave this paragraph out rather than replace it with an approximation.]

Je vous remercie de bien vouloir me faire parvenir cette copie par voie
postale a l'adresse ci-dessus, ou par voie electronique a l'adresse indiquee,
avant le 30 septembre 2026.

Je reste a votre disposition pour tout complement et pour le reglement des
frais de reproduction eventuels.

Je vous prie d'agreer, Madame, Monsieur, l'expression de mes salutations
distinguees.

                                        Marie Rousseau
```

## Choices made, and why

| Choice | Reason |
|---|---|
| Subject names the permit reference | it is what their filing system indexes; `Demande de document` would be lost |
| Second request stated in the subject | it changes how the letter is handled |
| Deadline as 30 September 2026 | section 3: a date, not `sous quinzaine` |
| Willingness to pay reproduction costs | removes the cheapest reason to refuse |
| Both postal and electronic delivery offered | removes the second cheapest |
| No comment on the earlier refusal | section 4: the letter may be read by a third party later |
| Full formule de politesse | recipient is a public administration, per the conventions table |
| Attachment listed and numbered | section 2, and it is the proof of the first request |

## What was refused

The legal citation. The instruction explicitly asked for it, and the draft is
delivered without it, with the gap marked, the reason stated, and the two ways
to fill it named.

That is not a partial delivery. The letter is complete and sendable in every
other respect. What is refused is the one element that would have been
fabricated, and refusing it in the draft is far cheaper than a public
administration finding it.

The gap marker also does something a silent omission would not: it tells the
user the paragraph should be removed entirely rather than softened into a
vague appeal to a right. A vague legal assertion is still an unverified legal
assertion.

## Gap list, delivered separately

```
Blocking, the letter cannot be sent without these:
1. Date on the permit
2. Address of the property
3. How the 3 June request was sent, and its tracking number if registered
4. Reason given for the refusal

Non blocking but weakening if left:
5. Exact department name at the town hall
6. Their reference on the refusal
7. Legal basis, or a decision to remove that paragraph

Marked for a qualified source: 7.
```

Separating blocking from non-blocking matters. Without it, a user fills the
four easy fields, misses the reason for refusal, and sends a second letter
that ignores the first refusal, which is the surest way to be refused again.
