import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/core/models/feed_model.dart';
import 'package:sociaanet/core/models/user_model.dart';
import 'package:sociaanet/features/feed/data/datasources/feed_datasource.dart';

class FeedRepository {
  final FeedRemoteDatasource _datasource;

  FeedRepository({FeedRemoteDatasource? datasource})
      : _datasource = datasource ?? FeedRemoteDatasourceImpl();

  Future<Either<Failure, FeedResponse>> getHomeFeed({int page = 1, int limit = 10}) async {
    try {
      final result = await _datasource.getHomeFeed(page: page, limit: limit);
      return Right(FeedResponse.fromJson(result));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, FeedResponse>> getExploreFeed({int page = 1, int limit = 20}) async {
    try {
      final result = await _datasource.getExploreFeed(page: page, limit: limit);
      return Right(FeedResponse.fromJson(result));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getReelsFeed({int page = 1, int limit = 10}) async {
    try {
      final result = await _datasource.getReelsFeed(page: page, limit: limit);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<SuggestedUser>>> getSuggestedUsers({int limit = 5}) async {
    try {
      final result = await _datasource.getSuggestedUsers(limit: limit);
      final usersList = result['users'] ?? result['items'] ?? [];
      final users = (usersList as List).map((json) => SuggestedUser.fromJson(json)).toList();
      return Right(users);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }
}
