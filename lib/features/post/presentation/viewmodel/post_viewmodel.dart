import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/post_model.dart';
import 'package:sociaanet/features/post/data/repositories/post_repository.dart';

class PostDetailState {
  final Post? post;
  final bool isLoading;
  final String? error;

  const PostDetailState({this.post, this.isLoading = false, this.error});

  PostDetailState copyWith({Post? post, bool? isLoading, String? error}) {
    return PostDetailState(
      post: post ?? this.post,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PostViewModel extends Notifier<PostDetailState> {
  late final PostRepository _repository;

  @override
  PostDetailState build() {
    _repository = PostRepository();
    return const PostDetailState();
  }

  Future<void> loadPost(String postId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.getPost(postId);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.toString()),
      (post) => state = state.copyWith(post: post, isLoading: false),
    );
  }

  Future<Post?> createPost({
    required String caption,
    required List<String> imagePaths,
    String? visibility,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.createPost(
      caption: caption,
      imagePaths: imagePaths,
      visibility: visibility,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.toString());
        return null;
      },
      (post) {
        state = state.copyWith(post: post, isLoading: false);
        return post;
      },
    );
  }

  Future<void> toggleLike(String postId) async {
    final currentPost = state.post;
    if (currentPost == null) return;

    // Optimistic update
    final wasLiked = currentPost.isLiked;
    state = state.copyWith(
      post: currentPost.copyWith(
        isLiked: !wasLiked,
        likesCount: wasLiked ? currentPost.likesCount - 1 : currentPost.likesCount + 1,
      ),
    );

    final result = wasLiked
        ? await _repository.unlikePost(postId)
        : await _repository.likePost(postId);

    result.fold(
      (failure) {
        // Revert on failure
        state = state.copyWith(post: currentPost, error: failure.toString());
      },
      (_) {},
    );
  }

  Future<void> toggleSave(String postId) async {
    final currentPost = state.post;
    if (currentPost == null) return;

    // Optimistic update
    final wasSaved = currentPost.isSaved;
    state = state.copyWith(
      post: currentPost.copyWith(isSaved: !wasSaved),
    );

    final result = wasSaved
        ? await _repository.unsavePost(postId)
        : await _repository.savePost(postId);

    result.fold(
      (failure) {
        state = state.copyWith(post: currentPost, error: failure.toString());
      },
      (_) {},
    );
  }
}

final postViewModelProvider = NotifierProvider<PostViewModel, PostDetailState>(
  PostViewModel.new,
);
