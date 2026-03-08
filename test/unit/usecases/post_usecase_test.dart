import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/features/post/data/datasources/post_datasource.dart';
import 'package:sociaanet/features/post/data/repositories/post_repository.dart';

@GenerateNiceMocks([MockSpec<PostRemoteDatasource>()])
import 'post_usecase_test.mocks.dart';

void main() {
  late PostRepository repository;
  late MockPostRemoteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockPostRemoteDatasource();
    repository = PostRepository(datasource: mockDatasource);
  });

  test('getPost should return Post on success', () async {
    when(mockDatasource.getPost('p1')).thenAnswer((_) async => {
          '_id': 'p1',
          'user_id': 'u1',
          'caption': 'Hello',
          'media_urls': <String>[],
          'media_type': 'image',
          'visibility': 'public',
          'likes_count': 5,
          'comments_count': 2,
          'created_at': '2025-01-01T00:00:00Z',
        });

    final result = await repository.getPost('p1');

    expect(result, isA<Right>());
    result.fold(
      (_) => fail('Should be Right'),
      (post) {
        expect(post.id, 'p1');
        expect(post.caption, 'Hello');
      },
    );
  });
}
