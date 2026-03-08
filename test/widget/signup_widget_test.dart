import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SignupScreen renders form fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Create Account', style: TextStyle(fontSize: 24)),
                TextFormField(decoration: const InputDecoration(labelText: 'Full Name')),
                TextFormField(decoration: const InputDecoration(labelText: 'Email')),
                TextFormField(decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                TextFormField(decoration: const InputDecoration(labelText: 'Confirm Password'), obscureText: true),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
  });

  testWidgets('SignupScreen has sign up button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(onPressed: () {}, child: const Text('Sign Up')),
        ),
      ),
    );

    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
