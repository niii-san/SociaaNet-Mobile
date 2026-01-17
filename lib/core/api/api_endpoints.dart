class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static const String userLogin = '/auth/login';
  static const String userSignup = '/auth/signup';
  static const String validateSession = '/auth/validate-session';
}
