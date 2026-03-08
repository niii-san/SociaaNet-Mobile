import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/core/models/user_model.dart';
import 'package:sociaanet/features/auth/data/datasources/auth_datasource.dart';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';
import 'package:sociaanet/features/auth/data/repositories/auth_repository.dart';
import 'package:sociaanet/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:sociaanet/features/auth/presentation/state/auth_state.dart';
import 'package:sociaanet/core/services/hive/hive_service.dart';

@GenerateNiceMocks([MockSpec<AuthRepositoryImpl>(), MockSpec<HiveService>()])
import 'auth_viewmodel_test.mocks.dart';

void main() {
  late MockAuthRepositoryImpl mockRepo;
  late MockHiveService mockHive;

  setUp(() {
    mockRepo = MockAuthRepositoryImpl();
    mockHive = MockHiveService();
  });

  test('signup succeeds and sets success state', () async {
    final response = SignupResponseModel(
      success: true,
      message: 'Created',
      userId: 'u1',
    );
    when(mockRepo.signup(
      fullName: anyNamed('fullName'),
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Right(response));

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
        hiveServiceProvider.overrideWithValue(mockHive),
      ],
    );
    addTearDown(container.dispose);

    await container.read(authViewModelProvider.notifier).signup(
          fullName: 'John',
          email: 'j@e.com',
          password: 'pass',
        );

    final state = container.read(authViewModelProvider);
    expect(state.status, AuthStatus.success);
    expect(state.errorMessage, isNull);
  });
}
