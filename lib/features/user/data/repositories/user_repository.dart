import 'dart:io';
import 'package:sociaanet/core/models/user_model.dart';
import 'package:sociaanet/features/user/data/datasources/user_datasource.dart';

/// Repository for user operations
class UserRepository {
  final UserDataSource _dataSource;

  UserRepository({UserDataSource? dataSource})
      : _dataSource = dataSource ?? UserDataSource();

  /// Upload user profile avatar
  /// Returns the updated user with new avatar URL
  Future<User> uploadAvatar(File imageFile) async {
    try {
      final response = await _dataSource.uploadAvatar(imageFile);
      return response.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Upload avatar by file path (convenience)
  Future<User> uploadAvatarByPath(String path) async {
    return uploadAvatar(File(path));
  }

  /// Fetch current user information
  Future<User> getUserInfo() async {
    try {
      final response = await _dataSource.getUserInfo();
      return response.user;
    } catch (e) {
      rethrow;
    }
  }
}
