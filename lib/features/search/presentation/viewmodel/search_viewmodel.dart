import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/features/search/data/datasources/search_datasource.dart';
import 'package:sociaanet/features/search/data/model/search_model.dart';
import 'package:sociaanet/features/search/data/repositories/search_repository.dart';

class SearchState {
  final List<SearchResult> users;
  final List<SearchResult> posts;
  final bool isLoading;
  final String query;
  final String? error;

  const SearchState({
    this.users = const [],
    this.posts = const [],
    this.isLoading = false,
    this.query = '',
    this.error,
  });

  SearchState copyWith({
    List<SearchResult>? users,
    List<SearchResult>? posts,
    bool? isLoading,
    String? query,
    String? error,
  }) {
    return SearchState(
      users: users ?? this.users,
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      error: error,
    );
  }
}

class SearchViewModel extends Notifier<SearchState> {
  late final SearchRepository _repository;

  @override
  SearchState build() {
    _repository = SearchRepository(SearchDatasource(ApiClient.instance));
    return const SearchState();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(isLoading: true, query: query, error: null);

    try {
      final users = await _repository.searchUsers(query);
      final posts = await _repository.searchPosts(query);
      state = state.copyWith(
        users: users,
        posts: posts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clear() {
    state = const SearchState();
  }
}

final searchProvider = NotifierProvider<SearchViewModel, SearchState>(
  SearchViewModel.new,
);
