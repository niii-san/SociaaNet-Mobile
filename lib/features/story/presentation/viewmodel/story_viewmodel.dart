import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/features/story/data/datasources/story_datasource.dart';
import 'package:sociaanet/features/story/data/model/story_model.dart';
import 'package:sociaanet/features/story/data/repositories/story_repository.dart';

class StoryState {
  final List<StoryModel> stories;
  final bool isLoading;
  final String? error;

  const StoryState({
    this.stories = const [],
    this.isLoading = false,
    this.error,
  });

  StoryState copyWith({
    List<StoryModel>? stories,
    bool? isLoading,
    String? error,
  }) {
    return StoryState(
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class StoryViewModel extends Notifier<StoryState> {
  late final StoryRepository _repository;

  @override
  StoryState build() {
    _repository = StoryRepository(StoryDatasource(ApiClient.instance));
    return const StoryState();
  }

  Future<void> loadStories() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final stories = await _repository.getStories();
      state = state.copyWith(stories: stories, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createStory(Map<String, dynamic> data) async {
    try {
      await _repository.createStory(data);
      await loadStories();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> markAsViewed(String storyId) async {
    try {
      await _repository.markAsViewed(storyId);
      final updated = state.stories.map((s) {
        if (s.id == storyId) {
          return StoryModel(
            id: s.id,
            userId: s.userId,
            username: s.username,
            avatarUrl: s.avatarUrl,
            mediaUrl: s.mediaUrl,
            mediaType: s.mediaType,
            createdAt: s.createdAt,
            expiresAt: s.expiresAt,
            isViewed: true,
          );
        }
        return s;
      }).toList();
      state = state.copyWith(stories: updated);
    } catch (_) {}
  }
}

final storyProvider = NotifierProvider<StoryViewModel, StoryState>(
  StoryViewModel.new,
);
