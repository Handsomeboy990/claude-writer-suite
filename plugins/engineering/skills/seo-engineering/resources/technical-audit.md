# Technical audit

Run against rendered pages in the target environment, never against templates.

## Fatal, check these first

```
production pages carrying noindex
robots file disallowing the whole site
the site reachable on several hostnames with no redirect
staging or preview environments indexable
content absent from the response body on pages that depend on search traffic
a certificate error, or mixed content, on any public page
5xx or 4xx on pages that should exist
```

Any one of these makes the rest irrelevant. All of them have shipped to
production in real projects, usually in the release that added a robots rule
for a staging environment.

## Addresses

```
one address per page, chosen
trailing slash behaviour consistent, enforced by redirect
case handled: one form serves, the other redirects
query parameters that do not change content do not create new addresses
filtered and sorted views: canonical to the base, or deliberately indexable
pagination: self canonical, with real links between pages
no session identifier in any address
no more than one redirect hop anywhere
```

## Per page metadata

```
title           unique, present, under the length that gets truncated
description     unique, present, written for a human
canonical       present, absolute, self referencing unless consolidating
robots          correct for this page's purpose
alternates      one per locale plus a default, and every one points back
social image    exists, correct dimensions, not a broken reference
```

Generate a report across every route rather than checking pages by hand:
duplicates in titles and descriptions are the finding, and they only appear
when the whole set is compared.

## Structure

```
exactly one main heading, describing the page
heading levels form an outline with no skips
main landmark present, and content inside it
navigation is anchors with addresses
images have alternative text
no text rendered as an image
breadcrumbs present where the hierarchy is deep, and marked up
```

## Structured data

```
type matches what the page is
every required property present
values identical to the visible content
no markup for content the user cannot see
validated against the vocabulary
tested on a real rendered page, not on a fragment
```

## Sitemap and robots

```
sitemap generated from real routes
excludes noindexed, redirected and removed pages
last modified dates are true, not the build time
referenced from the robots file
robots rules do not block resources needed to render the page
nothing sensitive is protected by a robots rule, since it is public and
  advisory
```

## Internationalization

```
each locale has its own address
each address is canonical to itself
alternates are reciprocal and complete
a default is declared for unmatched languages
the language is declared on the document
no automatic redirection that traps a user in the wrong locale
```

## After a URL change

```
redirect map produced before the change, one to one
permanent status for permanent moves
internal links updated, not relying on redirects
old sitemap retired, new one published
error rates and traffic watched for at least one indexing cycle
a rollback path, since a bad redirect map is expensive
```

## Report format

```
SEO-02  Filtered catalogue views generate indexable duplicate pages
Scope   /catalogue with 6 filters, producing roughly 400 addresses serving
        near identical content
Effect  the base page competes with its own variants
Fix     canonical to the base for filter combinations, keep the three
        combinations with real search demand as distinct indexable pages
        with their own titles
Owner   frontend
```
