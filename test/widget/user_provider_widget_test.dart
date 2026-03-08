import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/user_model.dart';
import 'package:sociaanet/features/auth/presentation/state/user_state.dart';

void main() {
  group('CurrentUserProvider Widget Tests', () {
    testWidgets('should display user data when currentUserProvider has data',
        (WidgetTester tester) async {
      // Arrange
      final testUser = User(
        id: 'test123',
        fullName: 'Test User',
        username: 'testuser',
        emailAddress: 'test@example.com',
        avatarUrl: null,
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set user
      container.read(currentUserProvider.notifier).setUser(testUser);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(currentUserProvider);
                  return Column(
                    children: [
                      Text(user?.fullName ?? 'No user'),
                      Text(user?.emailAddress ?? 'No email'),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('No user'), findsNothing);
    });

    testWidgets('should display "No user" when currentUserProvider is null',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(currentUserProvider);
                  return Text(user?.fullName ?? 'No user');
                },
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('No user'), findsOneWidget);
    });

    testWidgets('should update UI when user is set',
        (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(currentUserProvider);
                  return Text(user?.fullName ?? 'No user');
                },
              ),
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('No user'), findsOneWidget);

      // Update user
      container.read(currentUserProvider.notifier).setUser(
            User(
              id: 'new123',
              fullName: 'New User',
              username: 'newuser',
              emailAddress: 'new@example.com',
              createdAt: DateTime.parse('2024-02-01T00:00:00Z'),
            ),
          );

      await tester.pump();

      // Assert
      expect(find.text('New User'), findsOneWidget);
      expect(find.text('No user'), findsNothing);
    });

    testWidgets('should clear user data when clearUser is called',
        (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(currentUserProvider.notifier).setUser(
            User(
              id: 'test123',
              fullName: 'Test User',
              username: 'testuser',
              emailAddress: 'test@example.com',
              createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
            ),
          );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(currentUserProvider);
                  return Text(user?.fullName ?? 'No user');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test User'), findsOneWidget);

      // Clear user
      container.read(currentUserProvider.notifier).clearUser();
      await tester.pump();

      // Assert
      expect(find.text('No user'), findsOneWidget);
      expect(find.text('Test User'), findsNothing);
    });

    testWidgets('isUserLoggedInProvider should return correct login state',
        (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final isLoggedIn = ref.watch(isUserLoggedInProvider);
                  return Text(isLoggedIn ? 'Logged In' : 'Not Logged In');
                },
              ),
            ),
          ),
        ),
      );

      // Initial state - not logged in
      expect(find.text('Not Logged In'), findsOneWidget);

      // Set user - logged in
      container.read(currentUserProvider.notifier).setUser(
            User(
              id: 'test123',
              fullName: 'Test User',
              username: 'testuser',
              emailAddress: 'test@example.com',
              createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
            ),
          );

      await tester.pump();

      // Assert
      expect(find.text('Logged In'), findsOneWidget);
      expect(find.text('Not Logged In'), findsNothing);
    });
  });
}
