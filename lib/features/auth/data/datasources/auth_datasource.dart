import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';

abstract class AuthRemoteDatasource {
  Future<SignupResponseModel> signup(SignupRequestModel request);
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<ValidateSessionResponseModel> validateSession(String sessionId);
  Future<GetUserInfoResponseModel> getUserInfo();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasourceImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<SignupResponseModel> signup(SignupRequestModel request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.userSignup,
        data: request.toJson(),
      );

      return SignupResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // Extract error message from response body
      String errorMessage = 'Signup failed. Please try again.';

      final responseData = e.response?.data;
      if (responseData != null) {
        if (responseData is Map) {
          errorMessage =
              responseData['message'] ?? responseData['error'] ?? errorMessage;
        } else if (responseData is String) {
          errorMessage = responseData;
        }
      }

      throw Exception(errorMessage);
    }
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      print('📡 DATASOURCE: Calling API ${ApiEndpoints.userLogin}');
      final response = await _apiClient.post(
        ApiEndpoints.userLogin,
        data: request.toJson(),
      );

      print('📥 RAW API RESPONSE:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Data Type: ${response.data.runtimeType}');
      print('   Response Data: ${response.data}');

      final model = LoginResponseModel.fromJson(response.data);
      print('✅ Parsed LoginResponseModel:');
      print('   model.data.session_id = ${model.data.session_id}');
      print('   model.data.expires_at = ${model.data.expires_at}');

      return model;
    } on DioException catch (e) {
      // Extract error message from response body
      String errorMessage = 'Login failed. Please try again.';

      final responseData = e.response?.data;
      if (responseData != null) {
        if (responseData is Map) {
          errorMessage =
              responseData['message'] ?? responseData['error'] ?? errorMessage;
        } else if (responseData is String) {
          errorMessage = responseData;
        }
      }

      throw Exception(errorMessage);
    }
  }

  @override
  Future<ValidateSessionResponseModel> validateSession(String sessionId) async {
    try {
      print(
        '📡 DATASOURCE: Validating session with GET ${ApiEndpoints.validateSession}',
      );
      print('   Setting Authorization: Bearer $sessionId');

      // Set the session_id in Authorization header temporarily for validation
      final response = await _apiClient.get(
        ApiEndpoints.validateSession,
        options: Options(headers: {'Authorization': 'Bearer $sessionId'}),
      );

      print('✅ Session validation response: ${response.data}');
      return ValidateSessionResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // Extract error message from response body
      String errorMessage = 'Session validation failed.';

      final responseData = e.response?.data;
      if (responseData != null) {
        if (responseData is Map) {
          errorMessage =
              responseData['message'] ?? responseData['error'] ?? errorMessage;
        } else if (responseData is String) {
          errorMessage = responseData;
        }
      }

      throw Exception(errorMessage);
    }
  }

  @override
  Future<GetUserInfoResponseModel> getUserInfo() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getUserInfo);

      return GetUserInfoResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // Extract error message from response body
      String errorMessage = 'Failed to fetch user info.';

      final responseData = e.response?.data;
      if (responseData != null) {
        if (responseData is Map) {
          errorMessage =
              responseData['message'] ?? responseData['error'] ?? errorMessage;
        } else if (responseData is String) {
          errorMessage = responseData;
        }
      }

      throw Exception(errorMessage);
    }
  }
}

// Added password reset endpoint
