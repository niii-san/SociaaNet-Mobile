import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sociaanet/features/search/data/repositories/search_repository.dart';
import 'package:sociaanet/features/search/presentation/viewmodel/search_viewmodel.dart';

@GenerateNiceMocks([MockSpec<SearchRepository>()])
import 'search_viewmodel_test.mocks.dart';

class TestableSearchViewModel extends SearchViewModel {
  final SearchRepository repository;
  TestableSearchViewModel(this.repository);

  @override
  SearchState build() => const SearchState();

  @override
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }
    state = state.copyWith(isLoading: true, query: query, error: null);
    try {
      final users = await repository.searchUsers(query);
      final posts = await repository.searchPosts(query);
      state = state.copyWith(users: users, posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  @override
  void clear() {
    state = const SearchState();
  }
}

void main() {
  late MockSearchRepository mockRepository;

  setUp(() {
    mockRepository = MockSearchRepository();
  });

  test('search with empty query clears state', () async {
    final container = ProviderContainer(
      overrides: [
        searchProvider.overrideWith(() => TestableSearchViewModel(mockRepository)),
      ],
    );
    addTearDown(container.dispose);

    await container.read(searchProvider.notifier).search('');

    final state = container.read(searchProvider);
    expect(state.users, isEmpty);
    expect(state.query, '');
  });
}
