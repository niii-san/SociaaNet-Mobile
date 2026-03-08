import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sociaanet/features/search/data/datasources/search_datasource.dart';
import 'package:sociaanet/features/search/data/model/search_model.dart';
import 'package:sociaanet/features/search/data/repositories/search_repository.dart';

@GenerateNiceMocks([MockSpec<SearchDatasource>()])
import 'search_usecase_test.mocks.dart';

void main() {
  late SearchRepository repository;
  late MockSearchDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockSearchDatasource();
    repository = SearchRepository(mockDatasource);
  });

  test('searchUsers should return list of SearchResult on success', () async {
    when(mockDatasource.searchUsers('john')).thenAnswer((_) async => [
          {
            '_id': 'u1',
            'title': 'John Doe',
            'username': 'johndoe',
            'type': 'user',
          }
        ]);

    final results = await repository.searchUsers('john');

    expect(results, isA<List<SearchResult>>());
    expect(results.length, 1);
    expect(results.first.title, 'John Doe');
  });
}
