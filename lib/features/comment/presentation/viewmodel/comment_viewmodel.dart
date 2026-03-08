import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/comment_model.dart';
import 'package:sociaanet/features/comment/data/repositories/comment_repository.dart';

class CommentState {
  final List<Comment> comments;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const CommentState({
    this.comments = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
  });

  CommentState copyWith({
    List<Comment>? comments,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}

class CommentViewModel extends Notifier<CommentState> {
  late final CommentRepository _repository;

  @override
  CommentState build() {
    _repository = CommentRepository();
    return const CommentState();
  }

  Future<void> loadComments(String postId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.getComments(postId, page: 1);
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

  Future<void> loadMore(String postId) async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true);
    final nextPage = state.currentPage + 1;
    final result = await _repository.getComments(postId, page: nextPage);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.toString()),
      (comments) => state = state.copyWith(
        comments: [...state.comments, ...comments],
        isLoading: false,
        currentPage: nextPage,
        hasMore: comments.length >= 20,
      ),
    );
  }

  Future<void> addComment(String postId, String content, {String? parentId}) async {
    final result = await _repository.addComment(postId, content, parentId: parentId);
    result.fold(
      (failure) => state = state.copyWith(error: failure.toString()),
      (comment) {
        if (parentId != null) {
          final updatedComments = state.comments.map((c) {
            if (c.id == parentId) {
              return c.copyWith(replyCount: (c.replyCount ?? 0) + 1);
            }
            return c;
          }).toList();
          state = state.copyWith(comments: updatedComments);
        } else {
          state = state.copyWith(comments: [comment, ...state.comments]);
        }
      },
    );
  }

  Future<void> deleteComment(String postId, String commentId) async {
    final result = await _repository.deleteComment(postId, commentId);
    result.fold(
      (failure) => state = state.copyWith(error: failure.toString()),
      (_) => state = state.copyWith(
        comments: state.comments.where((c) => c.id != commentId).toList(),
      ),
    );
  }

  Future<void> toggleLikeComment(String commentId) async {
    final commentIndex = state.comments.indexWhere((c) => c.id == commentId);
    if (commentIndex == -1) return;

    final comment = state.comments[commentIndex];
    final isLiked = comment.isLiked ?? false;

    final result = isLiked
        ? await _repository.unlikeComment(commentId)
        : await _repository.likeComment(commentId);

    result.fold(
      (failure) => state = state.copyWith(error: failure.toString()),
      (updatedComment) {
        final updatedComments = List<Comment>.from(state.comments);
        updatedComments[commentIndex] = updatedComment;
        state = state.copyWith(comments: updatedComments);
      },
    );
  }
}

final commentViewModelProvider = NotifierProvider<CommentViewModel, CommentState>(
  CommentViewModel.new,
);
