// This is a basic Flutter widget test for verifying app initialization.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sociaanet/app/app.dart';

void main() {
  testWidgets('App should initialize without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Pump one frame to complete the build
    await tester.pump();

    // The test passes if no exception is thrown during initialization
    expect(true, isTrue);
  });
}
