import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sociaanet/core/models/user_model.dart';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';
import 'package:sociaanet/features/user/data/datasources/user_datasource.dart';
import 'package:sociaanet/features/user/data/repositories/user_repository.dart';

@GenerateNiceMocks([MockSpec<UserDataSource>()])
import 'user_usecase_test.mocks.dart';

void main() {
  late UserRepository repository;
  late MockUserDataSource mockDatasource;

  setUp(() {
    mockDatasource = MockUserDataSource();
    repository = UserRepository(dataSource: mockDatasource);
  });

  test('getUserInfo should return User on success', () async {
    final user = User(
      id: 'u1',
      fullName: 'John Doe',
      emailAddress: 'john@example.com',
      username: 'johndoe',
    );
    final response = GetUserInfoResponseModel(
      statusCode: 200,
      success: true,
      message: 'OK',
      user: user,
    );
    when(mockDatasource.getUserInfo()).thenAnswer((_) async => response);

    final result = await repository.getUserInfo();

    expect(result.fullName, 'John Doe');
    expect(result.username, 'johndoe');
  });
}
