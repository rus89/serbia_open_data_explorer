// ABOUTME: Basic widget test for the app shell and home route.
// ABOUTME: Pumps the app with ProviderScope and verifies home placeholder is shown.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serbia_open_data_explorer/main.dart';

void main() {
  testWidgets('App shows home placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SerbiaOpenDataExplorerApp()),
    );

    expect(find.text('Katalog'), findsOneWidget);
  });
}
