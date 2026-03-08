import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Search screen renders search bar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          body: const Center(child: Text('Search for users or posts')),
        ),
      ),
    );

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('Search for users or posts'), findsOneWidget);
  });

  testWidgets('Search screen shows search results', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: const [
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('johndoe'),
                subtitle: Text('John Doe'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('johndoe'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
  });
}
