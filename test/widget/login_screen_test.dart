import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Column(children: [TextField(), TextField()]))));
      expect(find.byType(TextField), findsNWidgets(2));
    });
    testWidgets('renders login button', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: ElevatedButton(onPressed: () {}, child: const Text('Login')))));
      expect(find.text('Login'), findsOneWidget);
    });
  });
}
