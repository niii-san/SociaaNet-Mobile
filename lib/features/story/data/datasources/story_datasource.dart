import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

class StoryDatasource {
  final ApiClient _apiClient;
  StoryDatasource(this._apiClient);

  Future<List<dynamic>> getStories() async {
    final response = await _apiClient.get('${ApiEndpoints.baseUrl}/stories');
    return response.data['stories'] ?? [];
  }

  Future<dynamic> createStory(Map<String, dynamic> data) async {
    final response = await _apiClient.post('${ApiEndpoints.baseUrl}/stories', data: data);
    return response.data;
  }

  Future<void> viewStory(String storyId) async {
    await _apiClient.post('${ApiEndpoints.baseUrl}/stories/$storyId/view');
  }
}
