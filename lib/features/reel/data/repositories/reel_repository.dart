import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/core/models/reel_model.dart';
import 'package:sociaanet/features/reel/data/datasources/reel_datasource.dart';

class ReelRepository {
  final ReelRemoteDatasource _datasource;

  ReelRepository({ReelRemoteDatasource? datasource})
      : _datasource = datasource ?? ReelRemoteDatasourceImpl();

  Future<Either<Failure, Map<String, dynamic>>> getReelsFeed({int page = 1, int limit = 10}) async {
    try {
      final data = await _datasource.getReelsFeed(page: page, limit: limit);
      final reels = (data['reels'] as List?)
              ?.map((r) => Reel.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [];
      return Right({
        'reels': reels,
        'pagination': data['pagination'],
      });
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> createReel({
    required String caption,
    required String videoPath,
    String? visibility,
  }) async {
    try {
      final result = await _datasource.createReel(
        caption: caption,
        videoPath: videoPath,
        visibility: visibility,
      );
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, Reel>> getReel(String reelId) async {
    try {
      final data = await _datasource.getReel(reelId);
      return Right(Reel.fromJson(data['reel'] ?? data));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateVisibility(String reelId, String visibility) async {
    try {
      await _datasource.updateReelVisibility(reelId, visibility);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> recordView(String reelId) async {
    try {
      await _datasource.recordView(reelId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> likeReel(String reelId) async {
    try {
      await _datasource.likeReel(reelId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> unlikeReel(String reelId) async {
    try {
      await _datasource.unlikeReel(reelId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> repostReel(String reelId) async {
    try {
      await _datasource.repostReel(reelId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> unrepostReel(String reelId) async {
    try {
      await _datasource.unrepostReel(reelId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> saveReel(String reelId) async {
    try {
      await _datasource.saveReel(reelId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> unsaveReel(String reelId) async {
    try {
      await _datasource.unsaveReel(reelId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
