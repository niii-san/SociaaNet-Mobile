import '../datasources/search_datasource.dart';
import '../model/search_model.dart';

class SearchRepository {
  final SearchDatasource _datasource;
  SearchRepository(this._datasource);

  Future<List<SearchResult>> searchUsers(String query) async {
    final data = await _datasource.searchUsers(query);
    return data.map((json) => SearchResult.fromJson(json)).toList();
  }

  Future<List<SearchResult>> searchPosts(String query) async {
    final data = await _datasource.searchPosts(query);
    return data.map((json) => SearchResult.fromJson(json)).toList();
  }
}

// Added recent searches caching
