---
description: "This set of rules provide a project guidelines."
alwaysApply: true
---

# This Project - Development Rules

## About Project

- A mobile catalog browser for Serbian open datasets.

Think: “Google Play–style explorer for Serbian public data”

## Characteristics

- Backend API from https://data.gov.rs/api/
- Useful for journalists, students, developers, NGOs

## Core features

- Search datasets by title / description
- Filter by:
  - organization
  - license
  - frequency
  - format (CSV, JSON, XLS…)
- Dataset detail page:
  - description
  - publisher
  - update frequency
  - download links

## Code Standards

- Use Riverpod for state management
- Follow Flutter best practices from .cursor/skills/flutter-developer
- Write tests for all features

## Team Structure

- Backend Agent: API, data models
- Frontend Agent: Flutter UI, widgets, navigation
- QA Agent: Tests, code review, quality checks

## Workflow

1. Strict plan before every feature implementation
2. Commit small and often
3. Backend builds feature first
4. Frontend integrates once backend done
5. QA writes tests for both
6. No merge without passing tests
