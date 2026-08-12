# Example: an attachment feature, first version and shipped version

Requirement: users attach files to a document, and other members of the same
organisation can download them.

## First version

```
POST /api/documents/:id/attachments
  save req.file to public/uploads/<original name>
  insert attachment row with the path
GET  /uploads/<name>  served statically
```

Five defects, all of which are classes rather than accidents:

```
1 the file lands in a directory the web server serves directly, so an
  uploaded HTML or SVG file executes on the application origin with the
  user's session
2 the stored name comes from the user, so a name with path separators writes
  outside the directory
3 no type check, no size check
4 downloads have no authorization at all: the path is the permission
5 a failed database insert leaves the file in place forever
```

## Shipped version

### Accept

```
1 authorization: the caller must be able to edit this document. Checked
  before the body is read.
2 size: 25 MB declared limit rejected at the header, and enforced again while
  streaming with a hard stop.
3 the bytes are streamed to a temporary location, never fully buffered.
4 type detected from the leading bytes. Allow list: PDF, PNG, JPEG, plain
  text, and the office formats the product documents. The declared header and
  the extension are ignored entirely.
5 for images, dimensions read from the header and checked against a maximum
  pixel count before any decoding.
6 the stored key is generated: att_<ulid>. The original name is kept as a
  metadata column, and it is escaped wherever it is displayed.
```

### Persist

```
7 the file is written to object storage first, under
  attachments/<organisationId>/<attachmentId>, outside anything served.
8 the database row is written second. If it fails, the storage object is
  deleted immediately, and if that deletion also fails, the orphan job
  removes it after 24 hours.
9 the row records: id, document, organisation, storage key, detected type,
  size, original name, checksum, uploader, created at.
```

The checksum earned itself twice: once to deduplicate the same file uploaded
five times by one user, and once to prove a corrupted download was corrupted
in transit rather than at rest.

### Serve

```
10 GET /api/attachments/:id/download
   authorization checked on every request against the document
   a signed storage URL is generated, valid 60 seconds, single use where the
   provider supports it
11 headers: the detected content type, a download disposition for anything
   not an image or a PDF, and no content type sniffing
12 images and PDFs are displayed inline, and they are served from a separate
   origin so that a crafted file cannot reach the application's cookies
```

### Process

```
13 thumbnails are generated in a job, not in the request
14 limits before decoding: 50 megapixels, 30 second timeout, memory cap
15 a failed thumbnail marks the attachment as having no preview. It never
   leaves a row pointing at an object that does not exist.
16 metadata carrying location is stripped from images, since the product has
   no use for it and users do not expect to publish their coordinates
```

### Lifecycle

```
17 deleting an attachment deletes the object immediately and the row
18 deleting a document deletes its attachments
19 deleting an organisation deletes every object under its prefix, verified
   by a test that counts objects before and after
20 the orphan job removes objects with no row after 24 hours, and reports the
   count, because a rising count means a defect in the write path
```

## What the adversarial pass found before release

```
row 12  an SVG was accepted as an image and displayed inline. Fixed by
        removing SVG from the allow list, which the product did not need.
row 17  a name of "../../etc/passwd" was already harmless because the stored
        name is generated, but it appeared unescaped in the interface, which
        was an HTML injection in the file list. Fixed.
row 23  a 64000 by 64000 pixel PNG of 40 KB killed the thumbnail worker.
        Fixed by checking dimensions before decoding.
row 36  killing the process between the storage write and the row insert left
        an object with no row. The orphan job existed but ran weekly. Moved
        to hourly, with a metric.
```

Four findings, none of which were visible in normal use, and all four are in
the matrix precisely because they are the ones that recur across products.
