import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/features/comment/data/datasources/comment_datasource.dart';
import 'package:sociaanet/features/comment/data/repositories/comment_repository.dart';

@GenerateNiceMocks([MockSpec<CommentRemoteDatasource>()])
import 'comment_usecase_test.mocks.dart';

void main() {
  late CommentRepository repository;
  late MockCommentRemoteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockCommentRemoteDatasource();
    repository = CommentRepository(datasource: mockDatasource);
  });

  test('getComments should return list of comments on success', () async {
    when(mockDatasource.getComments('p1', targetType: 'post', page: 1, limit: 20))
        .thenAnswer((_) async => {
              'comments': [
                {
                  '_id': 'c1',
                  'user_id': 'u1',
                  'content': 'Nice post!',
                  'created_at': '2025-01-01T00:00:00Z',
                  'likes_count': 0,
                  'replies_count': 0,
                  'is_liked': false,
                }
              ],
            });

    final result = await repository.getComments('p1');

    expect(result, isA<Right>());
    result.fold(
      (_) => fail('Should be Right'),
      (comments) {
        expect(comments.length, 1);
        expect(comments.first.content, 'Nice post!');
      },
    );
  });
}
