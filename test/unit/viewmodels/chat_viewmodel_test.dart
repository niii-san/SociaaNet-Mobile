import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/features/chat/data/repositories/chat_repository.dart';
import 'package:sociaanet/features/chat/presentation/viewmodel/chat_viewmodel.dart';

@GenerateNiceMocks([MockSpec<ChatRepositoryImpl>()])
import 'chat_viewmodel_test.mocks.dart';

void main() {
  late MockChatRepositoryImpl mockRepository;

  setUp(() {
    mockRepository = MockChatRepositoryImpl();
  });

  test('loadConversations sets conversations on success', () async {
    when(mockRepository.getConversations(page: 1, limit: 20))
        .thenAnswer((_) async => const Right([]));

    final container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    await container.read(chatViewModelProvider.notifier).loadConversations();

    final state = container.read(chatViewModelProvider);
    expect(state.status, ChatStatus.loaded);
  });
}
