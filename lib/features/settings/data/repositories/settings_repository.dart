import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/errors/failures.dart';
import 'package:sociaanet/core/models/settings_model.dart';
import 'package:sociaanet/features/settings/data/datasources/settings_datasource.dart';

class SettingsRepository {
  final SettingsRemoteDatasource _datasource;

  SettingsRepository({SettingsRemoteDatasource? datasource})
      : _datasource = datasource ?? SettingsRemoteDatasourceImpl();

  Future<Either<Failure, UserSettings>> getSettings() async {
    try {
      final data = await _datasource.getSettings();
      return Right(UserSettings.fromJson(data['settings'] ?? data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updatePrivacy(Map<String, dynamic> settings) async {
    try {
      await _datasource.updatePrivacy(settings);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updateNotifications(Map<String, dynamic> settings) async {
    try {
      await _datasource.updateNotifications(settings);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updateAppearance(Map<String, dynamic> settings) async {
    try {
      await _datasource.updateAppearance(settings);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updateFeed(Map<String, dynamic> settings) async {
    try {
      await _datasource.updateFeed(settings);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _datasource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
