import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/features/feed/data/datasources/feed_datasource.dart';
import 'package:sociaanet/features/feed/data/repositories/feed_repository.dart';

@GenerateNiceMocks([MockSpec<FeedRemoteDatasource>()])
import 'feed_usecase_test.mocks.dart';

void main() {
  late FeedRepository repository;
  late MockFeedRemoteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockFeedRemoteDatasource();
    repository = FeedRepository(datasource: mockDatasource);
  });

  test('getHomeFeed should return FeedResponse on success', () async {
    when(mockDatasource.getHomeFeed(page: 1, limit: 10))
        .thenAnswer((_) async => {
              'posts': <Map<String, dynamic>>[],
              'has_more': false,
              'page': 1,
              'total': 0,
              'total_pages': 1,
            });

    final result = await repository.getHomeFeed(page: 1);

    expect(result, isA<Right>());
    result.fold(
      (_) => fail('Should be Right'),
      (feedResponse) {
        expect(feedResponse.posts, isEmpty);
        expect(feedResponse.hasMore, false);
      },
    );
  });
}
