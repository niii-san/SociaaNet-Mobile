import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/core/models/notification_model.dart';
import 'package:sociaanet/features/notification/data/repositories/notification_repository.dart';
import 'package:sociaanet/features/notification/presentation/viewmodel/notification_viewmodel.dart';

@GenerateNiceMocks([MockSpec<NotificationRepository>()])
import 'notification_viewmodel_test.mocks.dart';

void main() {
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
  });

  test('loadNotifications sets notifications on success', () async {
    when(mockRepository.getNotifications(page: 1)).thenAnswer((_) async => Right({
          'notifications': <AppNotification>[],
          'pagination': {'totalPages': 1},
        }));

    final container = ProviderContainer(
      overrides: [
        notificationRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    await container.read(notificationViewModelProvider.notifier).loadNotifications();

    final state = container.read(notificationViewModelProvider);
    expect(state.isLoading, false);
  });
}
