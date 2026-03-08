import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/features/notification/data/datasources/notification_datasource.dart';
import 'package:sociaanet/features/notification/data/repositories/notification_repository.dart';

@GenerateNiceMocks([MockSpec<NotificationRemoteDatasource>()])
import 'notification_usecase_test.mocks.dart';

void main() {
  late NotificationRepository repository;
  late MockNotificationRemoteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockNotificationRemoteDatasource();
    repository = NotificationRepository(datasource: mockDatasource);
  });

  test('getUnreadCount should return count on success', () async {
    when(mockDatasource.getUnreadCount()).thenAnswer((_) async => 5);

    final result = await repository.getUnreadCount();

    expect(result, isA<Right>());
    result.fold(
      (_) => fail('Should be Right'),
      (count) => expect(count, 5),
    );
  });
}
