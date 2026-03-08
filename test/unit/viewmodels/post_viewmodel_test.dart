import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/core/models/post_model.dart';
import 'package:sociaanet/features/post/data/repositories/post_repository.dart';
import 'package:sociaanet/features/post/presentation/viewmodel/post_viewmodel.dart';

@GenerateNiceMocks([MockSpec<PostRepository>()])
import 'post_viewmodel_test.mocks.dart';

class TestablePostViewModel extends PostViewModel {
  final PostRepository repository;
  TestablePostViewModel(this.repository);

  @override
  PostDetailState build() => const PostDetailState();

  @override
  Future<void> loadPost(String postId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await repository.getPost(postId);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (post) => state = state.copyWith(post: post, isLoading: false),
    );
  }

  @override
  Future<Post?> createPost({required String caption, required List<String> imagePaths, String? visibility}) async { return null; }
  @override
  Future<void> toggleLike(String postId) async {}
  @override
  Future<void> toggleSave(String postId) async {}
}

void main() {
  late MockPostRepository mockRepository;

  setUp(() {
    mockRepository = MockPostRepository();
  });

  test('loadPost sets post on success', () async {
    final post = Post(
      id: 'p1',
      userId: 'u1',
      caption: 'Hello',
      mediaUrls: [],
      mediaType: 'image',
      visibility: 'public',
      createdAt: DateTime(2025, 1, 1),
    );
    when(mockRepository.getPost('p1')).thenAnswer((_) async => Right(post));

    final container = ProviderContainer(
      overrides: [
        postViewModelProvider.overrideWith(() => TestablePostViewModel(mockRepository)),
      ],
    );
    addTearDown(container.dispose);

    await container.read(postViewModelProvider.notifier).loadPost('p1');

    final state = container.read(postViewModelProvider);
    expect(state.post?.id, 'p1');
    expect(state.isLoading, false);
  });
}
