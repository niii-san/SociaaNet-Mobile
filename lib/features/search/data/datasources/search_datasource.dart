import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

class SearchDatasource {
  final ApiClient _apiClient;
  SearchDatasource(this._apiClient);

  Future<List<dynamic>> searchUsers(String query) async {
    final response = await _apiClient.get('${ApiEndpoints.baseUrl}/users/search?q=$query');
    return response.data['users'] ?? [];
  }

  Future<List<dynamic>> searchPosts(String query) async {
    final response = await _apiClient.get('${ApiEndpoints.baseUrl}/posts/search?q=$query');
    return response.data['posts'] ?? [];
  }
}
