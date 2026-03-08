import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Profile screen renders user info', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
              SizedBox(height: 8),
              Text('John Doe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('@johndoe', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('@johndoe'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('Profile screen shows stats', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [Text('42', style: TextStyle(fontWeight: FontWeight.bold)), Text('Posts')]),
              Column(children: [Text('1.2K', style: TextStyle(fontWeight: FontWeight.bold)), Text('Followers')]),
              Column(children: [Text('500', style: TextStyle(fontWeight: FontWeight.bold)), Text('Following')]),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('Following'), findsOneWidget);
  });
}
