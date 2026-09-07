# seo-engineering

The technical half of search visibility: crawlability, rendering strategy, one
canonical address per page, generated metadata, semantic structure, structured
data, sitemaps and robots rules, alternate language links, redirects and the
performance signals search engines measure.

- Inputs: the public surfaces, the URL structure, the rendering strategy, the
  locales.
- Outputs: URL strategy, metadata plan, structured data, crawl directives,
  redirect map.
- Depends on: engineering-core, frontend-engineering.
- Lateral: internationalization, accessibility-testing,
  performance-engineering.
- Downstream: deployment-engineering, migration-engineering, observability.

Applies to public surfaces only; an authenticated application should refuse
indexing. Everything is verified on rendered output, never on the template,
because that is where a production noindex hides.
