import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/features/report/data/datasources/report_datasource.dart';

class ReportRepository {
  final ReportRemoteDatasource _datasource;

  ReportRepository({ReportRemoteDatasource? datasource})
      : _datasource = datasource ?? ReportRemoteDatasourceImpl();

  Future<Either<Failure, void>> createReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? description,
  }) async {
    try {
      await _datasource.createReport(
        targetType: targetType,
        targetId: targetId,
        reason: reason,
        description: description,
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
