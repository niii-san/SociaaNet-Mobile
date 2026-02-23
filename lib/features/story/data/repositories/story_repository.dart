import '../datasources/story_datasource.dart';
import '../model/story_model.dart';

class StoryRepository {
  final StoryDatasource _datasource;
  StoryRepository(this._datasource);

  Future<List<StoryModel>> getStories() async {
    final data = await _datasource.getStories();
    return data.map((json) => StoryModel.fromJson(json)).toList();
  }

  Future<void> createStory(Map<String, dynamic> storyData) async {
    await _datasource.createStory(storyData);
  }

  Future<void> markAsViewed(String storyId) async {
    await _datasource.viewStory(storyId);
  }
}
