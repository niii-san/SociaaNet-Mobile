import 'dart:io';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';
import 'package:sociaanet/features/user/data/datasources/user_datasource.dart';

/// Repository for user operations
class UserRepository {
  final UserDataSource _dataSource;

  UserRepository({UserDataSource? dataSource})
      : _dataSource = dataSource ?? UserDataSource();

  /// Upload user profile avatar
  /// Returns the updated user model with new avatar URL
  Future<UserModel> uploadAvatar(File imageFile) async {
    try {
      final response = await _dataSource.uploadAvatar(imageFile);
      return response.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch current user information
  Future<UserModel> getUserInfo() async {
    try {
      final response = await _dataSource.getUserInfo();
      return response.user;
    } catch (e) {
      rethrow;
    }
  }
}
