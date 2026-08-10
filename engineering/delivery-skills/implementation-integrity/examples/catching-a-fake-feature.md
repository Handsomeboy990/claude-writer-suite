# Example: a demonstration that would have failed

Milestone M4, attestation generation, declared complete. Tests green. The
client demonstration is tomorrow.

## The static pass

```
grep over the M4 diff, 9 files

lib/services/certificate.ts:31   Promise.resolve on a literal
components/certificate-card.tsx:18  href="#"
app/api/certificates/route.ts:44 catch block with only a logger call
lib/pdf/generate.ts:12           TODO: real template
```

Four findings in nine files, on code that passes its tests.

## Finding 1, the one that matters

```ts
// lib/services/certificate.ts:28
export async function issueCertificate(enrolmentId: string) {
  const enrolment = await getEnrolment(enrolmentId)
  logger.info("certificate.issued", { enrolmentId })
  return Promise.resolve({
    id: `cert_${enrolmentId}`,
    url: `/certificates/cert_${enrolmentId}.pdf`,
    issuedAt: new Date().toISOString(),
  })
}
```

Every field looks right. There is a log line, a plausible identifier, a URL, a
timestamp. No certificate row is written and no PDF exists.

The test that protected it:

```ts
it("issues a certificate", async () => {
  const result = await issueCertificate("enr_1")
  expect(result.id).toBeTruthy()
  expect(result.url).toContain(".pdf")
})
```

Green forever, and it asserts the shape of a literal.

## The dynamic pass, which found it in one minute

```
1  complete a course as a trainee in the running application
2  UI shows "Your attestation is ready" and a download link
3  click the link
   404
4  query the database
   select count(*) from certificates;  ->  0
```

Step 3 is the demonstration that would have happened tomorrow, in front of the
client.

## The reload test on the rest of M4

```
enrolment completion    action, success shown, reload -> state persisted  pass
certificate issuance    action, success shown, reload -> nothing          fail
completion tracking     action, success shown, reload -> persisted        pass
```

One line of the three fails. Without the reload step, all three look
identical from the interface.

## Finding 3, the silent one

```ts
// app/api/certificates/route.ts:41
try {
  const certificate = await issueCertificate(enrolmentId)
  return Response.json(certificate)
} catch (error) {
  logger.error("certificate.failed", { error })
  return Response.json({ id: null, url: null }, { status: 200 })
}
```

A failure returns 200 with nulls. The client component treats a 200 as
success and renders the card with an empty link. Every failure in production
would have looked like a successful issuance with a broken download, and no
alert would have fired, because nothing returned an error status.

## What was done

```
Fixed  lib/services/certificate.ts
       real implementation: render the PDF, store it, insert the row,
       return the stored record
Fixed  app/api/certificates/route.ts
       failures return 500 with the project error shape; the client renders
       the error state
Fixed  components/certificate-card.tsx
       the link uses the stored URL; when absent, the card shows the failure
       state rather than a dead link
Fixed  lib/pdf/generate.ts
       the client's template, per requirement R4; the TODO removed

Tests replaced
       the shape assertion deleted
       new: issuing writes a row, the row's URL resolves, the PDF is a valid
       PDF with the trainee name in it
       new: a generation failure returns 500 and writes no row
       new: issuing twice for one enrolment returns the existing certificate
```

The last test came from a question the fake implementation had made
invisible: what happens if a trainee completes a course twice. The literal
returned a new identifier every time. The real implementation had to decide,
and the answer became a business rule.

## Finding 2 and 4, the ordinary ones

`href="#"` was a dead link left from the layout work. Fixed by pointing it at
the stored URL.

The TODO in the PDF template was real: the code produced a document with the
right text and the wrong layout, because the client's template had not
arrived when the task was written. It had arrived since. Fixed.

## The stub register after the pass

```
| # | What | Why | Form | Blocker | Visible to user as |
|---|---|---|---|---|---|
| S1 | mail delivery of the attestation | provider account not created | adapter throws NotConfigured; the certificate is issued and downloadable, only the email is unavailable | client to create the account | "Download your attestation. Email delivery will be enabled shortly." |
```

One entry, in the required form. The certificate itself is real; only the mail
step is blocked, and the user is told the truth about which part works.

## What the pass cost and returned

Twenty minutes of scanning and one database query. Against a demonstration
where the client clicks a download link and gets a 404, and every attestation
issued since the milestone was declared complete does not exist.
