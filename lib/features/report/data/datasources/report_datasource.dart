import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

abstract class ReportRemoteDatasource {
  Future<void> createReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? description,
  });
}

class ReportRemoteDatasourceImpl implements ReportRemoteDatasource {
  final ApiClient _apiClient;

  ReportRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<void> createReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? description,
  }) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.reports}',
        data: {
          'targetType': targetType,
          'targetId': targetId,
          'reason': reason,
          if (description != null) 'description': description,
        },
      );
    } on DioException catch (e) {
      throw Exception('Failed to submit report: ${e.message}');
    }
  }
}
