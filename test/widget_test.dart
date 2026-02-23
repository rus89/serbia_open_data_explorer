// ABOUTME: Basic widget test for the app shell and home route.
// ABOUTME: Pumps the app with ProviderScope and verifies home screen (search + list area) is shown.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serbia_open_data_explorer/main.dart';

void main() {
  testWidgets('App shows home screen with search and list area', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: SerbiaOpenDataExplorerApp()),
    );

    expect(find.text('Otvoreni podaci Srbije'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await tester.pumpAndSettle();

    final loadingOrErrorOrEmptyOrList =
        find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
        find
            .text('Nije moguće učitati skupove podataka.')
            .evaluate()
            .isNotEmpty ||
        find.text('Nema pronađenih skupova podataka.').evaluate().isNotEmpty ||
        find.byType(ListView).evaluate().isNotEmpty;
    expect(loadingOrErrorOrEmptyOrList, isTrue);
  });
}
