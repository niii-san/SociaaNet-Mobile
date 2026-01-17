import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/features/auth/data/datasources/auth_datasource.dart';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, SignupResponseModel>> signup({
    required String fullName,
    required String email,
    required String password,
  });

  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl({AuthRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? AuthRemoteDatasourceImpl();

  @override
  Future<Either<Failure, SignupResponseModel>> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final request = SignupRequestModel(
        fullName: fullName,
        email: email,
        password: password,
      );

      final response = await _remoteDatasource.signup(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequestModel(
        email: email,
        password: password,
      );

      final response = await _remoteDatasource.login(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
