import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/core/models/post_model.dart';
import 'package:sociaanet/features/post/data/datasources/post_datasource.dart';

class PostRepository {
  final PostRemoteDatasource _datasource;

  PostRepository({PostRemoteDatasource? datasource})
      : _datasource = datasource ?? PostRemoteDatasourceImpl();

  Future<Either<Failure, Post>> createPost({required String caption, required List<String> imagePaths, String? visibility}) async {
    try {
      final result = await _datasource.createPost(caption: caption, imagePaths: imagePaths, visibility: visibility);
      return Right(Post.fromJson(result));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, Post>> getPost(String postId) async {
    try {
      final result = await _datasource.getPost(postId);
      return Right(Post.fromJson(result));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> updatePostVisibility(String postId, String visibility) async {
    try {
      await _datasource.updatePostVisibility(postId, visibility);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> recordView(String postId) async {
    try {
      await _datasource.recordView(postId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> likePost(String postId) async {
    try {
      await _datasource.likePost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> unlikePost(String postId) async {
    try {
      await _datasource.unlikePost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> repostPost(String postId) async {
    try {
      await _datasource.repostPost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> unrepostPost(String postId) async {
    try {
      await _datasource.unrepostPost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> savePost(String postId) async {
    try {
      await _datasource.savePost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> unsavePost(String postId) async {
    try {
      await _datasource.unsavePost(postId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }
}
