import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/features/user/presentation/viewmodel/user_profile_viewmodel.dart';

void main() {
  group('UserProfileViewModel Widget Tests', () {
    testWidgets('should show loading indicator when status is loading',
        (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set loading state
      container.read(userProfileProvider.notifier).state = 
          UserProfileState(status: UserProfileStatus.loading);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(userProfileProvider);
                  if (state.status == UserProfileStatus.loading) {
                    return const CircularProgressIndicator();
                  }
                  return const Text('Not Loading');
                },
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Not Loading'), findsNothing);
    });

    testWidgets('should show success message when status is success',
        (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set success state
      container.read(userProfileProvider.notifier).state = 
          UserProfileState(status: UserProfileStatus.success);

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(userProfileProvider);
                  if (state.status == UserProfileStatus.success) {
                    return const Text('Success!');
                  }
                  return const Text('Not Success');
                },
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Success!'), findsOneWidget);
      expect(find.text('Not Success'), findsNothing);
    });

    testWidgets('should show error message when status is error',
        (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set error state
      container.read(userProfileProvider.notifier).state = 
          UserProfileState(
            status: UserProfileStatus.error,
            errorMessage: 'Upload failed',
          );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(userProfileProvider);
                  if (state.status == UserProfileStatus.error) {
                    return Text('Error: ${state.errorMessage}');
                  }
                  return const Text('No Error');
                },
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Error: Upload failed'), findsOneWidget);
      expect(find.text('No Error'), findsNothing);
    });

    testWidgets('should display initial state correctly',
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
                  final state = ref.watch(userProfileProvider);
                  return Text('Status: ${state.status.name}');
                },
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Status: initial'), findsOneWidget);
    });

    testWidgets('should react to state changes in UI',
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
                  final state = ref.watch(userProfileProvider);
                  return Column(
                    children: [
                      Text('Status: ${state.status.name}'),
                      if (state.errorMessage != null)
                        Text('Error: ${state.errorMessage}'),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Status: initial'), findsOneWidget);

      // Simulate state change to loading
      container.read(userProfileProvider.notifier).state = UserProfileState(
        status: UserProfileStatus.loading,
      );
      await tester.pump();

      expect(find.text('Status: loading'), findsOneWidget);

      // Simulate state change to error
      container.read(userProfileProvider.notifier).state = UserProfileState(
        status: UserProfileStatus.error,
        errorMessage: 'Network error',
      );
      await tester.pump();

      // Assert
      expect(find.text('Status: error'), findsOneWidget);
      expect(find.text('Error: Network error'), findsOneWidget);
    });
  });
}
