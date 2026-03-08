import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/features/chat/data/datasources/chat_datasource.dart';
import 'package:sociaanet/features/chat/data/repositories/chat_repository.dart';

@GenerateNiceMocks([MockSpec<ChatRemoteDatasource>()])
import 'chat_usecase_test.mocks.dart';

void main() {
  late ChatRepositoryImpl repository;
  late MockChatRemoteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockChatRemoteDatasource();
    repository = ChatRepositoryImpl(remoteDatasource: mockDatasource);
  });

  test('getConversations should return list on success', () async {
    when(mockDatasource.getConversations(page: 1, limit: 20))
        .thenAnswer((_) async => {
              'conversations': <Map<String, dynamic>>[],
            });

    final result = await repository.getConversations(page: 1, limit: 20);

    expect(result, isA<Right>());
  });
}
