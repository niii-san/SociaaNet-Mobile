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

  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email_address': email, 'password': password};
  }
}

/// Login data model
class LoginData {
  final String session_id;
  final String expires_at;

  LoginData({required this.session_id, required this.expires_at});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      session_id: json['session_id'] ?? '',
      expires_at: json['expires_at'] ?? '',
    );
  }
}

/// Response model for login API
class LoginResponseModel {
  final int statusCode;
  final bool success;
  final String message;
  final LoginData data;

  LoginResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? {};
    return LoginResponseModel(
      statusCode: json['status_code'] ?? 200,
      success: json['success'] ?? false,
      message: json['message'] ?? 'Login successful',
      data: LoginData.fromJson(dataJson),
    );
  }
}

/// Response model for session validation API
class ValidateSessionResponseModel {
  final int statusCode;
  final bool success;
  final String message;
  final bool isValid;

  ValidateSessionResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.isValid,
  });

  factory ValidateSessionResponseModel.fromJson(Map<String, dynamic> json) {
    // If the API returns success: true, the session is valid
    // The API doesn't have a separate is_valid field
    final success = json['success'] ?? false;
    return ValidateSessionResponseModel(
      statusCode: json['status_code'] ?? 200,
      success: success,
      message: json['message'] ?? 'Session validation result',
      isValid: success, // Use success field as isValid
    );
  }
}

/// User model for storing user information in memory
class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String emailAddress;
  final String? avatarUrl;
  final String createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.emailAddress,
    this.avatarUrl,
    required this.createdAt,
  });

  /// Get full avatar URL with base URL prepended
  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;

    String url = avatarUrl!;

    // Replace localhost with 10.0.2.2 for Android emulator
    if (url.contains('localhost')) {
      url = url.replaceAll('localhost', '10.0.2.2');
    }

    // If already a full URL, return it (with localhost replaced if needed)
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    // Otherwise prepend base URL
    return 'https://sociaanet-backend-production.up.railway.app$url';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      fullName: json['full_name'] ?? '',
      username: json['username'] ?? '',
      emailAddress: json['email_address'] ?? '',
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'full_name': fullName,
      'username': username,
      'email_address': emailAddress,
      'avatar_url': avatarUrl,
      'created_at': createdAt,
    };
  }
}

/// Response model for get user info API
class GetUserInfoResponseModel {
  final int statusCode;
  final bool success;
  final String message;
  final UserModel user;

  GetUserInfoResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.user,
  });

  factory GetUserInfoResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return GetUserInfoResponseModel(
      statusCode: json['status_code'] ?? 200,
      success: json['success'] ?? false,
      message: json['message'] ?? 'User fetched successfully',
      user: UserModel.fromJson(data),
    );
  }
}
