import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/core/models/comment_model.dart';
import 'package:sociaanet/features/comment/data/datasources/comment_datasource.dart';

class CommentRepository {
  final CommentRemoteDatasource _datasource;

  CommentRepository({CommentRemoteDatasource? datasource})
      : _datasource = datasource ?? CommentRemoteDatasourceImpl();

  Future<Either<Failure, List<Comment>>> getComments(String targetId, {String targetType = 'post', int page = 1, int limit = 20}) async {
    try {
      final result = await _datasource.getComments(targetId, targetType: targetType, page: page, limit: limit);
      final commentsList = result['comments'] ?? result['items'] ?? [];
      final comments = (commentsList as List).map((json) => Comment.fromJson(json)).toList();
      return Right(comments);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, Comment>> addComment(String targetId, String content, {String targetType = 'post'}) async {
    try {
      final result = await _datasource.addComment(targetId, content, targetType: targetType);
      return Right(Comment.fromJson(result));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, Comment>> replyToComment(String commentId, String content) async {
    try {
      final result = await _datasource.replyToComment(commentId, content);
      return Right(Comment.fromJson(result));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await _datasource.deleteComment(commentId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> likeComment(String commentId) async {
    try {
      await _datasource.likeComment(commentId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> unlikeComment(String commentId) async {
    try {
      await _datasource.unlikeComment(commentId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Comment>>> getReplies(String commentId, {int page = 1, int limit = 10}) async {
    try {
      final result = await _datasource.getReplies(commentId, page: page, limit: limit);
      final repliesList = result['replies'] ?? result['items'] ?? [];
      final replies = (repliesList as List).map((json) => Comment.fromJson(json)).toList();
      return Right(replies);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }
}
