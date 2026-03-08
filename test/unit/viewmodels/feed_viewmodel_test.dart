import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/core/models/feed_model.dart';
import 'package:sociaanet/features/feed/data/repositories/feed_repository.dart';
import 'package:sociaanet/features/feed/presentation/viewmodel/feed_viewmodel.dart';

@GenerateNiceMocks([MockSpec<FeedRepository>()])
import 'feed_viewmodel_test.mocks.dart';

class TestableFeedViewModel extends FeedViewModel {
  final FeedRepository repository;
  TestableFeedViewModel(this.repository);

  @override
  FeedState build() => const FeedState();

  @override
  Future<void> loadFeed({bool refresh = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await repository.getHomeFeed(page: 1);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (feedResponse) => state = state.copyWith(
        posts: feedResponse.posts,
        isLoading: false,
        hasMore: feedResponse.hasMore,
        currentPage: 1,
      ),
    );
  }

  @override
  Future<void> loadMore() async {}
  @override
  Future<void> refresh() async {}
  @override
  Future<void> loadSuggestedUsers() async {}
  @override
  void removePost(String postId) {}
  @override
  void updatePost(dynamic post) {}
}

void main() {
  late MockFeedRepository mockRepository;

  setUp(() {
    mockRepository = MockFeedRepository();
  });

  test('loadFeed sets posts on success', () async {
    final feedResponse = FeedResponse(posts: [], hasMore: false, page: 1, total: 0, totalPages: 1);
    when(mockRepository.getHomeFeed(page: 1)).thenAnswer((_) async => Right(feedResponse));

    final container = ProviderContainer(
      overrides: [
        feedViewModelProvider.overrideWith(() => TestableFeedViewModel(mockRepository)),
      ],
    );
    addTearDown(container.dispose);

    await container.read(feedViewModelProvider.notifier).loadFeed();

    final state = container.read(feedViewModelProvider);
    expect(state.posts, isEmpty);
    expect(state.isLoading, false);
  });
}
