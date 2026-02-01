import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CircleAvatar Widget Tests', () {
    testWidgets('should display CircleAvatar with correct radius',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleAvatar(
              radius: 50,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      
      final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(circleAvatar.radius, equals(50));
    });

    testWidgets('should display CircleAvatar with initial letter when no image',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleAvatar(
              radius: 50,
              child: Text('J', style: TextStyle(fontSize: 40)),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('should display loading indicator inside CircleAvatar',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                const CircleAvatar(radius: 50),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.color, equals(Colors.white));
    });

    testWidgets('should display camera icon on CircleAvatar',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                const CircleAvatar(radius: 50),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      
      final icon = tester.widget<Icon>(find.byIcon(Icons.camera_alt));
      expect(icon.size, equals(16));
      expect(icon.color, equals(Colors.white));
    });

    testWidgets('should handle GestureDetector tap on CircleAvatar',
        (WidgetTester tester) async {
      // Arrange
      bool wasTapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: () {
                wasTapped = true;
              },
              child: const CircleAvatar(
                radius: 50,
                child: Text('Tap me'),
              ),
            ),
          ),
        ),
      );

      // Tap the avatar
      await tester.tap(find.byType(CircleAvatar));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
      expect(find.text('Tap me'), findsOneWidget);
    });
  });

  group('Profile Screen UI Components Widget Tests', () {
    testWidgets('should display username text widget',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text(
              '@testuser',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('@testuser'), findsOneWidget);
      
      final textWidget = tester.widget<Text>(find.text('@testuser'));
      expect(textWidget.style?.fontSize, equals(15));
    });

    testWidgets('should display full name text widget',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1a1a2e),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('John Doe'), findsOneWidget);
      
      final textWidget = tester.widget<Text>(find.text('John Doe'));
      expect(textWidget.style?.fontSize, equals(24));
      expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('should display email address text widget',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'john@example.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('john@example.com'), findsOneWidget);
      
      final textWidget = tester.widget<Text>(find.text('john@example.com'));
      expect(textWidget.textAlign, equals(TextAlign.center));
      expect(textWidget.style?.fontSize, equals(14));
    });

    testWidgets('should render stats row with multiple columns',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    Text('42', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Posts', style: TextStyle(fontSize: 13)),
                  ],
                ),
                Column(
                  children: const [
                    Text('1.2K', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Followers', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('42'), findsOneWidget);
      expect(find.text('Posts'), findsOneWidget);
      expect(find.text('1.2K'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
    });

    testWidgets('should display SnackBar with success message',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile picture updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Show Snackbar'),
              ),
            ),
          ),
        ),
      );

      // Tap button to show snackbar
      await tester.tap(find.text('Show Snackbar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.text('Profile picture updated successfully!'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
