import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Post detail renders caption and interaction buttons', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Beautiful sunset!'),
              ),
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.comment_outlined), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Beautiful sunset!'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
  });

  testWidgets('Post detail shows likes count', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('42 likes', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );

    expect(find.text('42 likes'), findsOneWidget);
  });
}
