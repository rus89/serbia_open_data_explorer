# Serbia Open Data Explorer

A mobile catalog for Serbian open datasets. Browse, search, and discover public data from [data.gov.rs](https://data.gov.rs) in a simple, app-style experience.

---

## About

Serbia Open Data Explorer lets you explore the Serbian open data portal from your phone. Think of it as a **catalog app for public data**: search by title or description, narrow results with filters, and open any dataset to read the description, see the publisher and update frequency, and follow links to download files (CSV, JSON, XLS, and more).

The app is built for anyone who works with Serbian open data—**journalists**, **students**, **developers**, and **NGOs**—and uses the official [data.gov.rs API](https://data.gov.rs/api/1/) as its backend. The UI is in Serbian (latin script).

---

## Features

- **Search** — Find datasets by title or description.
- **Filters** — Narrow by organization, license, update frequency, and file format (e.g. CSV, JSON, XLS).
- **Dataset detail** — Full description, publisher, update frequency, and a list of resources with download links.
- **Download links** — Open resource URLs in the browser or system handler.

---

## Tech stack

- **Flutter** — Cross-platform mobile UI
- **Riverpod** — State management
- **Go Router** — Navigation and routing
- **data.gov.rs API** — Dataset catalog and metadata

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel; project uses SDK ^3.11.0)

---

## Getting started

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd serbia_open_data_explorer
   ```

2. **Install hooks** (recommended for consistent checks before commit)

   ```bash
   git config core.hooksPath .githooks
   ```

3. **Install dependencies and run**

   ```bash
   flutter pub get
   flutter run
   ```

---

## Development

### Run the app

```bash
flutter run
```

### Tests

Run all tests:

```bash
flutter test
```

Exclude integration tests (flow test that uses a fake API client; use when you want only real-API tests or when offline):

```bash
flutter test --exclude-tags=integration
```

### Static analysis

```bash
flutter analyze
```

---

## API

The app uses the Serbian open data portal API:

- **Base URL:** [https://data.gov.rs/api/1/](https://data.gov.rs/api/1/)

All dataset and resource metadata are loaded from this API.

---

## Project structure

- `lib/src/data/` — API client, models, and Riverpod providers
- `lib/src/presentation/` — Screens and UI
- `lib/src/routing/` — Route definitions and Go Router configuration
- `test/` — Unit and integration tests
