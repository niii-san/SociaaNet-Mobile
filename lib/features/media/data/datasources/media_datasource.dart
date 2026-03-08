import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

abstract class MediaRemoteDatasource {
  Future<Map<String, dynamic>> uploadPostMedia({
    required String caption,
    required List<String> imagePaths,
    String? visibility,
  });
  Future<Map<String, dynamic>> uploadReelMedia({
    required String caption,
    required String videoPath,
    String? visibility,
  });
  Future<Map<String, dynamic>> uploadChatMedia(String filePath);
}

class MediaRemoteDatasourceImpl implements MediaRemoteDatasource {
  final ApiClient _apiClient;

  MediaRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<Map<String, dynamic>> uploadPostMedia({
    required String caption,
    required List<String> imagePaths,
    String? visibility,
  }) async {
    try {
      final formData = FormData.fromMap({
        'caption': caption,
        if (visibility != null) 'visibility': visibility,
        'images': await Future.wait(
          imagePaths.map((path) => MultipartFile.fromFile(path)),
        ),
      });
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.mediaPost}',
        data: formData,
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to upload post media: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> uploadReelMedia({
    required String caption,
    required String videoPath,
    String? visibility,
  }) async {
    try {
      final formData = FormData.fromMap({
        'caption': caption,
        if (visibility != null) 'visibility': visibility,
        'video': await MultipartFile.fromFile(videoPath),
      });
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.mediaReel}',
        data: formData,
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to upload reel media: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> uploadChatMedia(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatUpload}',
        data: formData,
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to upload chat media: ${e.message}');
    }
  }
}
