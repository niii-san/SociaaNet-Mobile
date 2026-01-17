/// Request model for signup API
class SignupRequestModel {
  final String fullName;
  final String email;
  final String password;

  SignupRequestModel({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email_address': email,
      'password': password,
    };
  }
}

/// Response model for signup API
class SignupResponseModel {
  final bool success;
  final String message;
  final String? userId;

  SignupResponseModel({
    required this.success,
    required this.message,
    this.userId,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      success: json['success'] ?? true,
      message: json['message'] ?? 'Account created successfully',
      userId: json['userId'] ?? json['user_id'],
    );
  }
}

/// Request model for login API
class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email_address': email,
      'password': password,
    };
  }
}

/// Response model for login API
class LoginResponseModel {
  final int statusCode;
  final bool success;
  final String message;
  final String sessionId;
  final String expiresAt;

  LoginResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.sessionId,
    required this.expiresAt,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return LoginResponseModel(
      statusCode: json['status_code'] ?? 200,
      success: json['success'] ?? false,
      message: json['message'] ?? 'Login successful',
      sessionId: data?['session_id'] ?? '',
      expiresAt: data?['expires_at'] ?? '',
    );
  }
}
