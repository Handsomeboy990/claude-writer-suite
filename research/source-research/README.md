# source-research

The gathering half of research: builds a search strategy, works down the source
hierarchy to primaries, actually retrieves and reads each source, extracts
findings with exact attribution and location, and tracks coverage so the search
stops at saturation rather than fatigue.

- Inputs: a framed question from research-core.
- Outputs: search strategy, consulted sources, attributed findings, coverage map.
- Depends on: research-core.
- Downstream: source-verification, synthesis-reporting, competitive-analysis.

A list of search results is not research; a set of sources opened, read, and
attributed is. A finding whose only source is an aggregator, with no primary
behind it, is flagged as unverified, not reported as established.
