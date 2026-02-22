# AppServices Pattern

## Core Principle

**MANDATORY**: Access all services via `appServices` singleton.

```dart
appServices.serviceName.method()
```

**NEVER** directly instantiate services.

## Initialization Check

```dart
if (!appServices.isInitialized) {
  // Wait or show loading state
  return CircularProgressIndicator();
}

// Safe to access services
final user = appServices.user.currentUser;
```

## Available Services

| Service | Purpose | Example |
|---------|---------|---------|
| `user` | User data, profile | `appServices.user.currentUser` |
| `itinerary` | Itinerary CRUD | `appServices.itinerary.getById(id)` |
| `product` | Hotels, flights, activities | `appServices.product.getHotels()` |
| `contact` | Contact management | `appServices.contact.create(data)` |
| `authorization` | Permission checks | `appServices.authorization.canEdit()` |
| `authentication` | Auth state, login/logout | `appServices.authentication.isLoggedIn` |
| `ui` | UI state, theme | `appServices.ui.isDarkMode` |
| `currency` | Currency conversion | `appServices.currency.convert(...)` |
| `location` | Location services | `appServices.location.getCurrentLocation()` |
| `dashboard` | Dashboard data | `appServices.dashboard.getStats()` |
| `pwa` | PWA features | `appServices.pwa.isInstalled` |
| `error` | Error handling | `appServices.error.handleError(e, msg)` |

## Service Lifecycle

```dart
// Cleanup on logout (automatic)
appServices.reset()

// Individual service refresh
await appServices.itinerary.refresh()
```

## Common Patterns

### Loading Data

```dart
@override
void initState() {
  super.initState();
  _loadData();
}

Future<void> _loadData() async {
  if (!appServices.isInitialized) return;

  setState(() => _isLoading = true);
  try {
    final data = await appServices.itinerary.getAll();
    if (mounted) {
      setState(() {
        _items = data;
        _isLoading = false;
      });
    }
  } catch (e) {
    appServices.error.handleError(e, 'Failed to load data');
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
```

### Creating Data

```dart
Future<void> _createItem() async {
  if (!appServices.authorization.canCreate()) {
    _showPermissionError();
    return;
  }

  try {
    await appServices.contact.create(_formData);
    if (mounted) {
      context.pop(); // Return to list
    }
  } catch (e) {
    appServices.error.handleError(e, 'Failed to create');
  }
}
```

### Updating Data

```dart
Future<void> _updateItem(String id) async {
  if (!appServices.authorization.canEdit()) {
    _showPermissionError();
    return;
  }

  try {
    await appServices.itinerary.update(id, _changes);
    // Notify success
  } catch (e) {
    appServices.error.handleError(e, 'Failed to update');
  }
}
```

### Deleting Data

```dart
Future<void> _deleteItem(String id) async {
  if (!appServices.authorization.canDelete()) {
    _showPermissionError();
    return;
  }

  final confirmed = await _showConfirmDialog();
  if (!confirmed) return;

  try {
    await appServices.contact.delete(id);
    if (mounted) {
      context.pop();
    }
  } catch (e) {
    appServices.error.handleError(e, 'Failed to delete');
  }
}
```

## Anti-Patterns (AVOID)

```dart
// WRONG: Direct instantiation
final service = ContactService();

// CORRECT: Use appServices
final service = appServices.contact;

// WRONG: No initialization check
final user = appServices.user.currentUser;

// CORRECT: Check first
if (appServices.isInitialized) {
  final user = appServices.user.currentUser;
}

// WRONG: No error handling
await appServices.contact.create(data);

// CORRECT: With error handling
try {
  await appServices.contact.create(data);
} catch (e) {
  appServices.error.handleError(e, 'Failed');
}
```
