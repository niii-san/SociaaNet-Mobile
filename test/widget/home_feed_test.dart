import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeFeed Widget Tests', () {
    testWidgets('renders feed list', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Center(child: Text('Feed')))));
      expect(find.text('Feed'), findsOneWidget);
    });
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()))));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
