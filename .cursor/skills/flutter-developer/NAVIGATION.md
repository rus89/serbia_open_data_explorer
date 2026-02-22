# Navigation Patterns (GoRouter)

## Basic Navigation

```dart
// Navigate replacing current route
context.go('/contacts');

// Navigate pushing onto stack
context.push('/contacts/details', extra: contactId);

// Go back
context.pop();

// Pop with result
context.pop(result);
```

## Available Routes

| Route | Purpose |
|-------|---------|
| `/` | Dashboard/Home |
| `/contacts` | Contact list |
| `/contacts/details` | Contact detail view |
| `/products` | Product catalog |
| `/products/hotels` | Hotels list |
| `/products/flights` | Flights list |
| `/products/activities` | Activities list |
| `/itineraries` | Itinerary list |
| `/itineraries/details` | Itinerary detail |
| `/itineraries/preview` | Itinerary preview |
| `/users` | User management |
| `/profile` | User profile |
| `/settings` | App settings |

## Passing Data

### Via Extra Parameter

```dart
// Navigate with data
context.push('/contacts/details', extra: {
  'contactId': contact.id,
  'mode': 'edit',
});

// Receive in destination
final args = GoRouterState.of(context).extra as Map<String, dynamic>;
final contactId = args['contactId'];
```

### Via Path Parameters

```dart
// Route definition
GoRoute(
  path: '/itineraries/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ItineraryDetailWidget(id: id);
  },
),

// Navigate
context.go('/itineraries/$itineraryId');
```

### Via Query Parameters

```dart
// Navigate with query params
context.go('/contacts?filter=active&sort=name');

// Receive
final filter = GoRouterState.of(context).uri.queryParameters['filter'];
```

## Navigation Guards

### Check Authentication

```dart
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    if (!appServices.authentication.isLoggedIn) {
      return '/login';
    }
    return null;
  },
  builder: (context, state) => AdminWidget(),
),
```

### Check Permissions

```dart
GoRoute(
  path: '/users',
  redirect: (context, state) {
    if (!appServices.authorization.canManageUsers()) {
      return '/unauthorized';
    }
    return null;
  },
  builder: (context, state) => UsersWidget(),
),
```

## Nested Navigation

```dart
ShellRoute(
  builder: (context, state, child) {
    return MainLayout(child: child);
  },
  routes: [
    GoRoute(path: '/dashboard', ...),
    GoRoute(path: '/contacts', ...),
    GoRoute(path: '/itineraries', ...),
  ],
),
```

## Navigation with Result

```dart
// Navigate and wait for result
final result = await context.push<Contact>('/contacts/select');
if (result != null) {
  // Use selected contact
}

// Return result from destination
context.pop(selectedContact);
```

## Common Patterns

### After Form Submit

```dart
Future<void> _onSubmit() async {
  if (!_formKey.currentState!.validate()) return;

  try {
    await appServices.contact.create(_formData);
    if (mounted) {
      context.pop(); // Return to list
    }
  } catch (e) {
    // Handle error
  }
}
```

### Confirmation Before Leave

```dart
Future<bool> _onWillPop() async {
  if (!_hasChanges) return true;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Discard changes?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Discard')),
      ],
    ),
  );

  return confirmed ?? false;
}
```

### Deep Linking

```dart
// Handle deep links
GoRoute(
  path: '/itineraries/:id/share/:token',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    final token = state.pathParameters['token']!;
    return SharedItineraryWidget(id: id, token: token);
  },
),
```

## Anti-Patterns (AVOID)

```dart
// WRONG: Hardcoded routes
Navigator.pushNamed(context, '/contacts');

// CORRECT: Use GoRouter
context.go('/contacts');

// WRONG: Direct Navigator.push
Navigator.push(context, MaterialPageRoute(...));

// CORRECT: Use GoRouter
context.push('/contacts/new');
```
