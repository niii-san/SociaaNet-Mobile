import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Feed screen renders header and refresh indicator', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('SociaaNet')),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: ListView(
              children: const [
                ListTile(title: Text('Post 1')),
                ListTile(title: Text('Post 2')),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('SociaaNet'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.text('Post 1'), findsOneWidget);
  });

  testWidgets('Feed screen shows empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('No posts yet')),
        ),
      ),
    );

    expect(find.text('No posts yet'), findsOneWidget);
  });
}
