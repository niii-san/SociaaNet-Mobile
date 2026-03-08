import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Notification screen renders list items', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Notifications')),
          body: ListView(
            children: const [
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('John started following you'),
                subtitle: Text('2 hours ago'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('John started following you'), findsOneWidget);
  });

  testWidgets('Notification screen shows empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 64),
                Text('No notifications'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('No notifications'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none), findsOneWidget);
  });
}
