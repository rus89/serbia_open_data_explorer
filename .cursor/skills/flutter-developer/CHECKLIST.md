# Flutter Developer Checklist

## Pre-Implementation

- [ ] Backend APIs ready (if feature requires them)
- [ ] AppServices patterns reviewed
- [ ] Navigation structure understood
- [ ] Permission requirements documented
- [ ] Similar implementations identified for reference

## Implementation

### AppServices Integration
- [ ] Access via `appServices.serviceName.method()`
- [ ] Check `appServices.isInitialized` before data access
- [ ] Never directly instantiate services

### State Management
- [ ] Controllers initialized in `initState()`
- [ ] Resources disposed in `dispose()`
- [ ] Check `mounted` before setState after async

### Navigation
- [ ] Use GoRouter (`context.go()`, `context.push()`, `context.pop()`)
- [ ] No hardcoded route strings
- [ ] Data passed via `extra` parameter

### Permissions
- [ ] Check `appServices.authorization.can*()` before privileged ops
- [ ] Show/hide UI based on permissions
- [ ] Handle unauthorized gracefully

### Error Handling
- [ ] Try-catch on all async operations
- [ ] User-friendly error messages
- [ ] Log errors via `appServices.error.handleError()`

### Design System
- [ ] Import from `design_system/index.dart`
- [ ] Use BukeerButton, BukeerTextField, etc.
- [ ] Follow BukeerColors, BukeerTypography, BukeerSpacing

### Naming Conventions
- [ ] Files: `snake_case.dart`
- [ ] Classes: `PascalCase`
- [ ] Variables/functions: `camelCase`
- [ ] Private: `_underscore`

## Post-Implementation

### Testing
- [ ] `flutter analyze` passes (zero issues)
- [ ] `flutter test` passes (all tests)
- [ ] New tests written for new logic
- [ ] Coverage maintained (≥80%)

### Quality
- [ ] Feature navigable without errors
- [ ] Permissions enforced correctly
- [ ] Error states handled gracefully
- [ ] Responsive on different screen sizes

## Handoff Criteria

- [ ] Implementation complete (bug fix, feature, or screens)
- [ ] AppServices integration complete
- [ ] Navigation flows functional (if multi-screen)
- [ ] Permission checks implemented
- [ ] Error handling with proper user feedback

## Output Files

| Type | Location |
|------|----------|
| Widgets | `lib/bukeer/[feature]/[screens].dart` |
| Services | Updated via `appServices.*` |
| Navigation | Route definitions in router |

## Escalation

| Situation | Action |
|-----------|--------|
| Blocked by backend | Escalate to `backend-dev` |
| Architecture unclear | Consult `architecture-analyzer` |
| After 2 retry attempts | Human review |

## Next Skill

After implementation complete:
- **Primary**: `testing-agent` for test validation
- **Trigger**: Feature implementation complete
