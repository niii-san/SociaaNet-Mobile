import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sociaanet/features/story/data/model/story_model.dart';
import 'package:sociaanet/features/story/data/repositories/story_repository.dart';
import 'package:sociaanet/features/story/presentation/viewmodel/story_viewmodel.dart';

@GenerateNiceMocks([MockSpec<StoryRepository>()])
import 'story_viewmodel_test.mocks.dart';

class TestableStoryViewModel extends StoryViewModel {
  final StoryRepository repository;
  TestableStoryViewModel(this.repository);

  @override
  StoryState build() => const StoryState();

  @override
  Future<void> loadStories() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final stories = await repository.getStories();
      state = state.copyWith(stories: stories, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  @override
  Future<void> createStory(Map<String, dynamic> data) async {}
}

void main() {
  late MockStoryRepository mockRepository;

  setUp(() {
    mockRepository = MockStoryRepository();
  });

  test('loadStories sets stories on success', () async {
    final story = StoryModel(
      id: 's1',
      userId: 'u1',
      username: 'johndoe',
      mediaUrl: 'https://example.com/story.jpg',
      mediaType: 'image',
      createdAt: DateTime(2025, 1, 1),
      expiresAt: DateTime(2025, 1, 2),
      isViewed: false,
    );
    when(mockRepository.getStories()).thenAnswer((_) async => [story]);

    final container = ProviderContainer(
      overrides: [
        storyProvider.overrideWith(() => TestableStoryViewModel(mockRepository)),
      ],
    );
    addTearDown(container.dispose);

    await container.read(storyProvider.notifier).loadStories();

    final state = container.read(storyProvider);
    expect(state.stories.length, 1);
    expect(state.stories.first.username, 'johndoe');
  });
}
