# Letter conventions by country

Conventions, not translations. A French letter is not an English letter in
French. Where a country is absent from this file, find its convention from a
source rather than extrapolating from a neighbour.

## France

```
<Sender name>                                    <Recipient name or department>
<Address>                                        <Organisation>
<Postcode City>                                  <Address>
<Email, telephone>                               <Postcode City>

Vos references : <theirs>
Nos references : <yours>

                                                 <City>, le 11 aout 2026

Objet : <one line, factual>
Pieces jointes : <numbered list>

Madame, Monsieur,

<Purpose, first sentence.>

<Facts, dated.>

<Request, with a date.>

<Availability.>

Je vous prie d'agreer, Madame, Monsieur, l'expression de mes salutations
distinguees.

                                                 <Signature>
                                                 <Name>
                                                 <Function>
```

Rules specific to France:

- `Objet` sits before the salutation, not after it.
- The salutation used in the closing repeats the opening one exactly. Opening
  with `Madame, Monsieur` and closing with `Monsieur` is a visible error.
- No comma after `Madame, Monsieur` in the closing formula beyond those
  already shown.
- Between equals in a professional context, `Cordialement` or `Bien
  cordialement` is correct, and the full formula reads as distant.
- To a public administration, a court or a hierarchical superior, use the full
  formula.
- French typography applies: non-breaking space before `:`, `;`, `?`, `!`,
  guillemets for quotation. See `writing/resources/typographie-francaise.md`.

Closing formulas by relationship:

| Relationship | Formula |
|---|---|
| Administration, institution, superior | Je vous prie d'agreer, Madame, Monsieur, l'expression de mes salutations distinguees. |
| Formal, known correspondent | Je vous prie d'agreer, Madame, l'expression de mes sentiments respectueux. |
| Professional equal | Cordialement, or Bien cordialement, |
| Ongoing exchange | Bien a vous, |

## United Kingdom

```
<Sender name>
<Address>
<Postcode>

<Recipient name>
<Organisation>
<Address>
<Postcode>

11 August 2026

Dear Mr Dupont

Re: <one line>

<Purpose, first sentence.>

<Facts.>

<Request, with a date.>

Yours sincerely

<Signature>
<Name>
<Function>

Enc. <numbered list>
```

Rules specific to the United Kingdom:

- `Yours sincerely` when the recipient is named. `Yours faithfully` after
  `Dear Sir or Madam`. Using the wrong one is noticed.
- No full stop after `Mr`, `Mrs`, `Dr`.
- No comma after the salutation or the closing, in the open punctuation style
  now standard. Be consistent within the document.
- `Re:` sits after the salutation.

## United States

```
<Sender name>
<Address>
<City, State ZIP>

August 11, 2026

<Recipient name>
<Title>
<Organisation>
<Address>
<City, State ZIP>

Dear Mr. Dupont:

<Purpose, first sentence.>

<Facts.>

<Request, with a date.>

Sincerely,

<Signature>
<Name>
<Function>

Enclosures: <numbered list>
```

Rules specific to the United States:

- Colon after the salutation in formal correspondence, not a comma.
- Full stop after `Mr.`, `Mrs.`, `Dr.`
- Date before the recipient block.
- `Sincerely,` with a comma.

## Germany

```
<Sender name>
<Strasse Nummer>
<PLZ Ort>

<Empfanger>
<Organisation>
<Strasse Nummer>
<PLZ Ort>

                                                 Berlin, den 11.08.2026

Betreff: <one line>

Sehr geehrte Damen und Herren,

<Purpose, first sentence.>

<Facts.>

<Request, with a date.>

Mit freundlichen Grussen

<Signature>
<Name>
<Funktion>

Anlagen: <numbered list>
```

Rules specific to Germany:

- `Betreff` before the salutation.
- Comma after the salutation, and the first line of the body starts lowercase
  where grammar allows.
- No comma after `Mit freundlichen Grussen`.
- DIN 5008 governs layout in formal and commercial correspondence.

## Elements that never vary

Whatever the country:

| Element | Rule |
|---|---|
| Subject line | names the object and the action, and is indexable |
| Purpose | first sentence of the body |
| Deadlines | absolute dates, never durations |
| Requests | one action, to someone able to take it |
| Attachments | numbered, listed, and actually enclosed |
| References | theirs and yours, both, when the exchange has any |
| Signature block | name and function, always; hand signature where required |

## Digital delivery

- The PDF filename is itself an index entry:
  `2026-08-11-request-permit-PC-2024-0871.pdf`.
- The email body repeats the subject and the request in three lines. Do not
  make the recipient open an attachment to learn what it is.
- Attachments named as they are listed in the letter. `piece-1-contrat.pdf`,
  not `scan_0012.pdf`.
- PDF metadata carries title and author, not the temporary filename left by
  the exporter. See `pdf-production`.

## Register, common failures

| Failure | Effect |
|---|---|
| Padding before the purpose | the reader does not know whose file this is |
| Duration instead of a date | a dispute about when the clock started |
| Two requests in one letter | one gets answered |
| Emotion or accusation | the letter becomes evidence about you |
| An unverified legal reference | quoted back, and wrong |
| A threat you will not carry out | costs every later letter its weight |
| Ambiguity | resolved the other way, at the moment it counts |
