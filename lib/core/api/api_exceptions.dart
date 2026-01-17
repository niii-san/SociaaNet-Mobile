import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: null,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Send timeout. Please try again.',
          statusCode: null,
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Receive timeout. Please try again.',
          statusCode: null,
        );
      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Bad certificate. Connection is not secure.',
          statusCode: null,
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled.',
          statusCode: null,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Connection error. Please check your internet connection.',
          statusCode: null,
        );
      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: error.message ?? 'An unexpected error occurred.',
          statusCode: null,
        );
    }
  }

  static ApiException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    String message;
    switch (statusCode) {
      case 400:
        message = _extractErrorMessage(responseData) ?? 'Bad request.';
        break;
      case 401:
        message = 'Unauthorized. Please login again.';
        break;
      case 403:
        message = 'Forbidden. You don\'t have permission to access this resource.';
        break;
      case 404:
        message = 'Resource not found.';
        break;
      case 409:
        message = _extractErrorMessage(responseData) ?? 'Conflict occurred.';
        break;
      case 422:
        message = _extractErrorMessage(responseData) ?? 'Validation error.';
        break;
      case 500:
        message = 'Internal server error. Please try again later.';
        break;
      case 502:
        message = 'Bad gateway. Server is temporarily unavailable.';
        break;
      case 503:
        message = 'Service unavailable. Please try again later.';
        break;
      default:
        message = _extractErrorMessage(responseData) ?? 'Something went wrong.';
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      data: responseData,
    );
  }

  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is String) return data;
    if (data is Map) {
      // Try common error message field names
      return data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String? ??
          data['msg'] as String?;
    }
    return null;
  }

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
