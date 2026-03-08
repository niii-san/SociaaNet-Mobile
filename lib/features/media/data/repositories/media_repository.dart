import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/errors/failures.dart';
import 'package:sociaanet/features/media/data/datasources/media_datasource.dart';

class MediaRepository {
  final MediaRemoteDatasource _datasource;

  MediaRepository({MediaRemoteDatasource? datasource})
      : _datasource = datasource ?? MediaRemoteDatasourceImpl();

  Future<Either<Failure, Map<String, dynamic>>> uploadPostMedia({
    required String caption,
    required List<String> imagePaths,
    String? visibility,
  }) async {
    try {
      final result = await _datasource.uploadPostMedia(
        caption: caption,
        imagePaths: imagePaths,
        visibility: visibility,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> uploadReelMedia({
    required String caption,
    required String videoPath,
    String? visibility,
  }) async {
    try {
      final result = await _datasource.uploadReelMedia(
        caption: caption,
        videoPath: videoPath,
        visibility: visibility,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> uploadChatMedia(String filePath) async {
    try {
      final result = await _datasource.uploadChatMedia(filePath);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
