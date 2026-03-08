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

  Future<Post?> createPost(Map<String, dynamic> data, {List<String>? mediaPaths}) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.createPost(data, mediaPaths: mediaPaths);
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

  Future<bool> deletePost(String postId) async {
    final result = await _repository.deletePost(postId);
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.toString());
        return false;
      },
      (_) => true,
    );
  }

  Future<void> toggleLike(String postId) async {
    final currentPost = state.post;
    if (currentPost == null) return;

    final isLiked = currentPost.isLiked ?? false;
    final result = isLiked
        ? await _repository.unlikePost(postId)
        : await _repository.likePost(postId);

    result.fold(
      (failure) => state = state.copyWith(error: failure.toString()),
      (updatedPost) => state = state.copyWith(post: updatedPost),
    );
  }

  Future<void> toggleSave(String postId) async {
    final currentPost = state.post;
    if (currentPost == null) return;

    final isSaved = currentPost.isSaved ?? false;
    final result = isSaved
        ? await _repository.unsavePost(postId)
        : await _repository.savePost(postId);

    result.fold(
      (failure) => state = state.copyWith(error: failure.toString()),
      (updatedPost) => state = state.copyWith(post: updatedPost),
    );
  }
}

final postViewModelProvider = NotifierProvider<PostViewModel, PostDetailState>(
  PostViewModel.new,
);
