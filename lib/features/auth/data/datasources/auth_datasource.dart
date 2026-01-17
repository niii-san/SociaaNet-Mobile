import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';

abstract class AuthRemoteDatasource {
  Future<SignupResponseModel> signup(SignupRequestModel request);
  Future<LoginResponseModel> login(LoginRequestModel request);
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
          errorMessage = responseData['message'] ?? 
                        responseData['error'] ?? 
                        errorMessage;
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
      final response = await _apiClient.post(
        ApiEndpoints.userLogin,
        data: request.toJson(),
      );

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // Extract error message from response body
      String errorMessage = 'Login failed. Please try again.';
      
      final responseData = e.response?.data;
      if (responseData != null) {
        if (responseData is Map) {
          errorMessage = responseData['message'] ?? 
                        responseData['error'] ?? 
                        errorMessage;
        } else if (responseData is String) {
          errorMessage = responseData;
        }
      }
      
      throw Exception(errorMessage);
    }
  }
}
