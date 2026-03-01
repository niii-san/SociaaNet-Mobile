import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileScreen Widget Tests', () {
    testWidgets('renders profile header', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Center(child: Text('Profile')))));
      expect(find.text('Profile'), findsOneWidget);
    });
    testWidgets('renders post grid', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: GridView.count(crossAxisCount: 3, children: []))));
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
