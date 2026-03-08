import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/core/models/models.dart';

class PostService {
  final ApiClient _apiClient = ApiClient.instance;

  Future<Post> getPost(String postId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.postDetail(postId)}',
    );
    return Post.fromJson(response.data['data'] ?? response.data);
  }

  Future<Post> createPost({
    String? caption,
    List<File>? imageFiles,
    String visibility = 'public',
  }) async {
    final formData = FormData.fromMap({
      if (caption != null) 'caption': caption,
      'visibility': visibility,
    });

    if (imageFiles != null) {
      for (final file in imageFiles) {
        final fileName = file.path.split(Platform.pathSeparator).last;
        final ext = fileName.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';
        if (ext == 'png') mimeType = 'image/png';

        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType.parse(mimeType),
          ),
        ));
      }
    }

    final response = await _apiClient.uploadFile(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.mediaPost}',
      formData: formData,
    );
    return Post.fromJson(response.data['data'] ?? response.data);
  }

  Future<void> updatePostVisibility(String postId, String visibility) async {
    await _apiClient.put(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.postVisibility(postId)}',
      data: {'visibility': visibility},
    );
  }

  Future<void> recordView(String postId) async {
    await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.viewPost(postId)}',
    );
  }

  Future<Map<String, dynamic>> likePost(String postId) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.likePost(postId)}',
    );
    return response.data['data'] ?? response.data;
  }

  Future<Map<String, dynamic>> unlikePost(String postId) async {
    final response = await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.likePost(postId)}',
    );
    return response.data['data'] ?? response.data;
  }

  Future<void> repostPost(String postId) async {
    await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.repostPost(postId)}',
    );
  }

  Future<void> unrepostPost(String postId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.repostPost(postId)}',
    );
  }

  Future<void> savePost(String postId) async {
    await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.savePost(postId)}',
    );
  }

  Future<void> unsavePost(String postId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.savePost(postId)}',
    );
  }
}
