# Flutter Development Patterns

Reference patterns for Bukeer Flutter development.

## State Management Pattern

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final appServices = AppServices();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## Error Handling (MANDATORY)

```dart
try {
  final result = await appServices.contact.create(data);
  // Handle success
} catch (e) {
  appServices.error.handleError(e, 'Failed to create contact');
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to create contact')),
    );
  }
}
```

## Permissions (ALWAYS CHECK)

```dart
if (appServices.authorization.canDeleteItinerary()) {
  // Show delete button
}
```

Common permissions:
- `canCreateItinerary()`
- `canEditItinerary()`
- `canDeleteItinerary()`
- `canViewFinancialReports()`
- `canManageUsers()`
- `canManageRoles()`

## Multi-Currency

```dart
final usdAmount = await appServices.currency.convertAmount(
  amount: 5000000, from: 'COP', to: 'USD'
);
final formatted = appServices.currency.formatCurrency(
  amount: 1250, currency: 'USD'
);
```

## Naming Conventions (STRICT)

| Type | Convention | Example |
|------|------------|---------|
| Files/folders | snake_case | `user_profile_widget.dart` |
| Classes | PascalCase | `UserProfileWidget` |
| Variables/functions | camelCase | `userName`, `updateUserProfile` |
| Private members | _underscore | `_privateVariable` |

## Design System Usage

```dart
import 'package:bukeer/design_system/index.dart';

// Colors
BukeerColors.primary    // #4B39EF
BukeerColors.secondary  // #39D2C0
BukeerColors.success    // #249689
BukeerColors.error      // #FF5963

// Typography
BukeerTypography  // Outfit + Readex Pro fonts

// Spacing (4px base system)
BukeerSpacing.xs  // 12px
BukeerSpacing.s   // 16px
BukeerSpacing.m   // 20px
BukeerSpacing.l   // 24px

// Components
BukeerButton, BukeerTextField, BukeerModal
```

## Async Safety Patterns (MANDATORY)

### 1. `context.mounted` Check After `await`

Always check `mounted` (or `context.mounted`) after any `await` before using `context`:

```dart
// ✅ CORRECT
await someAsyncOperation();
if (!mounted) return;
Navigator.of(context).pop();

// ✅ CORRECT - multiple awaits need checks between each
await firstOperation();
if (!mounted) return;
await secondOperation();
if (!mounted) return;
ScaffoldMessenger.of(context).showSnackBar(...);

// ❌ WRONG - using context after await without check
await someAsyncOperation();
Navigator.of(context).pop(); // May crash if widget disposed
```

### 2. Null-Safe JWT Token Pattern

Never use `currentJwtToken!`. Always use a local variable with null check:

```dart
// ✅ CORRECT
final token = currentJwtToken;
if (token == null || token.isEmpty) return;
final response = await SomeApiCall.call(authToken: token);

// ❌ WRONG - crashes if token is null
final response = await SomeApiCall.call(authToken: currentJwtToken!);
```

### 3. Navigator in Modals

Always use `rootNavigator: true` for modal navigation:

```dart
// ✅ CORRECT
showDialog(context: context, useRootNavigator: true, builder: ...);
Navigator.of(context, rootNavigator: true).pop(result);

// ❌ WRONG - may fail with nested navigators
Navigator.pop(context);
Navigator.of(context).pop();
```

## Development Workflow

1. **Analyze Requirements**
   - Understand the feature/component purpose
   - Identify required permissions
   - Determine which AppServices are needed
   - Check if similar patterns exist

2. **Design Architecture**
   - Follow Model-View pattern (*_widget.dart, *_model.dart)
   - Plan state management approach
   - Identify reusable Design System components
   - Consider responsive/adaptive requirements

3. **Implement with Best Practices**
   - Use Bukeer Design System components exclusively
   - Implement proper error handling with try-catch
   - Add permission checks before privileged operations
   - Use late initialization for controllers
   - Always check `mounted` before using BuildContext after async
   - Dispose resources properly
   - Follow directory structure: lib/bukeer/feature_name/

4. **Quality Assurance**
   - Write unit tests for logic
   - Test permission checks
   - Verify responsive behavior
   - Check accessibility
