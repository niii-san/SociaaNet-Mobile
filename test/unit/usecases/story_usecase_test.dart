import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sociaanet/features/story/data/datasources/story_datasource.dart';
import 'package:sociaanet/features/story/data/model/story_model.dart';
import 'package:sociaanet/features/story/data/repositories/story_repository.dart';

@GenerateNiceMocks([MockSpec<StoryDatasource>()])
import 'story_usecase_test.mocks.dart';

void main() {
  late StoryRepository repository;
  late MockStoryDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockStoryDatasource();
    repository = StoryRepository(mockDatasource);
  });

  test('getStories should return list of StoryModel on success', () async {
    when(mockDatasource.getStories()).thenAnswer((_) async => [
          {
            '_id': 's1',
            'userId': 'u1',
            'username': 'johndoe',
            'mediaUrl': 'https://example.com/story.jpg',
            'mediaType': 'image',
            'createdAt': '2025-01-01T00:00:00Z',
            'expiresAt': '2025-01-02T00:00:00Z',
            'isViewed': false,
          }
        ]);

    final stories = await repository.getStories();

    expect(stories, isA<List<StoryModel>>());
    expect(stories.length, 1);
    expect(stories.first.username, 'johndoe');
  });
}
