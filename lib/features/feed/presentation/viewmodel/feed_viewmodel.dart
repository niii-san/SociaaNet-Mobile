import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/feed_model.dart';
import 'package:sociaanet/core/models/post_model.dart';
import 'package:sociaanet/core/models/user_model.dart';
import 'package:sociaanet/features/feed/data/repositories/feed_repository.dart';

class FeedState {
  final List<FeedPost> posts;
  final List<SuggestedUser> suggestedUsers;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const FeedState({
    this.posts = const [],
    this.suggestedUsers = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
  });

  FeedState copyWith({
    List<FeedPost>? posts,
    List<SuggestedUser>? suggestedUsers,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}

class FeedViewModel extends Notifier<FeedState> {
  late final FeedRepository _repository;

  @override
  FeedState build() {
    _repository = FeedRepository();
    return const FeedState();
  }

  Future<void> loadFeed() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.getHomeFeed(page: 1);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.toString()),
      (feedResponse) => state = state.copyWith(
        posts: feedResponse.posts.map((p) => FeedPost.fromJson(p.toJson())).toList(),
        isLoading: false,
        currentPage: 1,
        hasMore: feedResponse.hasMore,
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;
    final result = await _repository.getHomeFeed(page: nextPage);
    result.fold(
      (failure) => state = state.copyWith(isLoadingMore: false, error: failure.toString()),
      (feedResponse) {
        final newPosts = feedResponse.posts.map((p) => FeedPost.fromJson(p.toJson())).toList();
        state = state.copyWith(
          posts: [...state.posts, ...newPosts],
          isLoadingMore: false,
          currentPage: nextPage,
          hasMore: feedResponse.hasMore,
        );
      },
    );
  }

  Future<void> refresh() async {
    await loadFeed();
    await loadSuggestedUsers();
  }

  Future<void> loadSuggestedUsers() async {
    final result = await _repository.getSuggestedUsers();
    result.fold(
      (failure) {},
      (users) => state = state.copyWith(suggestedUsers: users),
    );
  }

  void removePost(String postId) {
    state = state.copyWith(
      posts: state.posts.where((p) => p.id != postId).toList(),
    );
  }

  void updatePost(FeedPost updatedPost) {
    final index = state.posts.indexWhere((p) => p.id == updatedPost.id);
    if (index != -1) {
      final updatedPosts = List<FeedPost>.from(state.posts);
      updatedPosts[index] = updatedPost;
      state = state.copyWith(posts: updatedPosts);
    }
  }
}

final feedViewModelProvider = NotifierProvider<FeedViewModel, FeedState>(
  FeedViewModel.new,
);
