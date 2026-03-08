import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/features/auth/data/datasources/auth_datasource.dart';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';
import 'package:sociaanet/features/auth/data/repositories/auth_repository.dart';

@GenerateNiceMocks([MockSpec<AuthRemoteDatasource>()])
import 'auth_usecase_test.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockAuthRemoteDatasource();
    repository = AuthRepositoryImpl(remoteDatasource: mockDatasource);
  });

  test('signup should return SignupResponseModel on success', () async {
    final response = SignupResponseModel(
      success: true,
      message: 'Account created',
      userId: 'user123',
    );
    when(mockDatasource.signup(any)).thenAnswer((_) async => response);

    final result = await repository.signup(
      fullName: 'John Doe',
      email: 'john@example.com',
      password: 'password123',
    );

    expect(result, isA<Right>());
    result.fold(
      (_) => fail('Should be Right'),
      (r) {
        expect(r.success, true);
        expect(r.userId, 'user123');
      },
    );
  });
}
