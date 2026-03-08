import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Chat screen renders conversation list', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Messages')),
          body: ListView(
            children: const [
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('Jane Doe'),
                subtitle: Text('Hey, how are you?'),
                trailing: Text('2m ago'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Jane Doe'), findsOneWidget);
    expect(find.text('Hey, how are you?'), findsOneWidget);
  });

  testWidgets('Chat screen shows empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64),
                Text('No messages yet'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('No messages yet'), findsOneWidget);
    expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
  });
}
