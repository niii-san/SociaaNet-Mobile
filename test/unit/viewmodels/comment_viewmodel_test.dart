import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/core/models/comment_model.dart';
import 'package:sociaanet/features/comment/data/repositories/comment_repository.dart';
import 'package:sociaanet/features/comment/presentation/viewmodel/comment_viewmodel.dart';

@GenerateNiceMocks([MockSpec<CommentRepository>()])
import 'comment_viewmodel_test.mocks.dart';

class TestableCommentViewModel extends CommentViewModel {
  final CommentRepository repository;
  TestableCommentViewModel(this.repository);

  @override
  CommentState build() => const CommentState();

  @override
  Future<void> loadComments(String postId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await repository.getComments(postId, page: 1);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.toString()),
      (comments) => state = state.copyWith(
        comments: comments,
        isLoading: false,
        currentPage: 1,
        hasMore: comments.length >= 20,
      ),
    );
  }

  @override
  Future<void> addComment(String postId, String content, {String? parentId}) async {}
  @override
  Future<void> deleteComment(String commentId) async {}
  @override
  Future<void> toggleLikeComment(String commentId) async {}
}

void main() {
  late MockCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRepository();
  });

  test('loadComments sets comments on success', () async {
    final comment = Comment(
      id: 'c1',
      userId: 'u1',
      content: 'Nice!',
      createdAt: DateTime(2025, 1, 1),
    );
    when(mockRepository.getComments('p1', page: 1))
        .thenAnswer((_) async => Right([comment]));

    final container = ProviderContainer(
      overrides: [
        commentViewModelProvider.overrideWith(() => TestableCommentViewModel(mockRepository)),
      ],
    );
    addTearDown(container.dispose);

    await container.read(commentViewModelProvider.notifier).loadComments('p1');

    final state = container.read(commentViewModelProvider);
    expect(state.comments.length, 1);
    expect(state.comments.first.content, 'Nice!');
    expect(state.isLoading, false);
  });
}
