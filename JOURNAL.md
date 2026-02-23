---
name: Journal for AI agents
description: They use it to remember the most important elements about the project, so they can recall it later.
---

# Agent Journal

- Each entry: `## YYYY-MM-DD — [Agent/session note]` followed by freeform notes.
- Read this at session start. Append entries; never delete existing ones.
- keep elements organized.

## 2026-02-23 — Website analysis (data.gov.rs/sr/datasets)

- Analysed https://data.gov.rs/sr/, /sr/datasets/, /sr/reuses/, and a dataset detail page to align app with portal and find useful additions.
- Findings: portal offers sort (reuses, followers, last modified, created), topic filter/themes, reuses section (72 items), „Otvoriti na portalu” (dataset.page), metrics (reuses, followers), posts/vesti, CSV export. API supports sort, topic filter, and has reuses + posts endpoints.
- Added doc/WEBSITE_ANALYSIS.md with concrete suggestions: add sort and optional topic filter in Phase 4; add „Otvoriti na portalu” link and reuses count on detail in Phase 5; optional later: reuses screen, posts, tags. Plan file was not edited per user request.
- Extended API_DISCOVERY.md with reuses and posts endpoints for future use.

## 2026-02-23 — Phase 6 data layer tests

- Confirmed data layer tests cover search (API: list+pagination, query, filters; providers: load, refetch on params, filters, page), getById (API: found + not-found throws; providers: exists + throws), and error handling.
- Added API client test: `searchDatasets throws when server returns non-200` using real API (baseUrl with nonexistent path yields 404). Error handling now covers both getDatasetById (non-existent id) and searchDatasets (HTTP error).
- All tests use real API; no mocks. `flutter test test/src/data/` and `flutter analyze` pass.
