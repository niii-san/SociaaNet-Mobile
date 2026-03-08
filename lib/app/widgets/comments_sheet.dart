import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/services/comment_service.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/app/widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsSheet extends ConsumerStatefulWidget {
  final String postId;
  final String type; // 'post' or 'reel'
  final VoidCallback? onCommentAdded;

  const CommentsSheet({
    super.key,
    required this.postId,
    this.type = 'post',
    this.onCommentAdded,
  });

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isSending = false;
  String? _replyingTo;
  String? _replyingToUsername;
  int _page = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        _hasMore &&
        !_isLoading) {
      _loadMore();
    }
  }

  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(commentServiceProvider);
      final comments = widget.type == 'post'
          ? await service.getPostComments(widget.postId, page: 1, limit: 20)
          : await service.getReelComments(widget.postId, page: 1, limit: 20);
      setState(() {
        _comments = comments;
        _isLoading = false;
        _hasMore = comments.length >= 20;
        _page = 2;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (!_hasMore) return;
    try {
      final service = ref.read(commentServiceProvider);
      final comments = widget.type == 'post'
          ? await service.getPostComments(widget.postId, page: _page, limit: 20)
          : await service.getReelComments(widget.postId, page: _page, limit: 20);
      setState(() {
        _comments.addAll(comments);
        _hasMore = comments.length >= 20;
        _page++;
      });
    } catch (_) {}
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    try {
      final service = ref.read(commentServiceProvider);
      Comment? newComment;

      if (_replyingTo != null) {
        newComment = await service.replyToComment(
          _replyingTo!,
          text,
        );
      } else {
        newComment = widget.type == 'post'
            ? await service.addPostComment(widget.postId, text)
            : await service.addReelComment(widget.postId, text);
      }

      if (newComment != null) {
        setState(() {
          _comments.insert(0, newComment!);
          _replyingTo = null;
          _replyingToUsername = null;
        });
        _commentController.clear();
        widget.onCommentAdded?.call();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send comment')),
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _toggleLikeComment(Comment comment) async {
    final index = _comments.indexOf(comment);
    if (index == -1) return;

    final wasLiked = comment.isLiked;
    setState(() {
      _comments[index] = comment.copyWith(
        isLiked: !wasLiked,
        likesCount: wasLiked ? comment.likesCount - 1 : comment.likesCount + 1,
      );
    });

    try {
      final service = ref.read(commentServiceProvider);
      if (wasLiked) {
        await service.unlikeComment(comment.commentId);
      } else {
        await service.likeComment(comment.commentId);
      }
    } catch (_) {
      setState(() {
        _comments[index] = comment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Comments',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),

          // Comments list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : _comments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No comments yet',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Be the first to comment!',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          return _CommentItem(
                            comment: _comments[index],
                            onLike: () => _toggleLikeComment(_comments[index]),
                            onReply: () {
                              setState(() {
                                _replyingTo = _comments[index].commentId;
                                _replyingToUsername = _comments[index].author.username;
                              });
                              _commentController.text = '@${_comments[index].author.username} ';
                              FocusScope.of(context).requestFocus();
                            },
                          );
                        },
                      ),
          ),

          // Reply indicator
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              child: Row(
                children: [
                  Text(
                    'Replying to @$_replyingToUsername',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _replyingTo = null;
                        _replyingToUsername = null;
                      });
                      _commentController.clear();
                    },
                    child: Icon(Icons.close, size: 18, color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ),

          // Input field
          Container(
            padding: EdgeInsets.fromLTRB(12, 8, 8, 8 + bottomInset),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(color: theme.dividerColor, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 6),
                _isSending
                    ? const SizedBox(
                        width: 36,
                        height: 36,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: _sendComment,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback onReply;

  const _CommentItem({
    required this.comment,
    required this.onLike,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(
            imageUrl: comment.author.avatarUrl,
            fallbackName: comment.author.fullName,
            radius: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: comment.author.username,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: '  '),
                      TextSpan(
                        text: comment.content,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      timeago.format(comment.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(
                            comment.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 14,
                            color: comment.isLiked
                                ? Colors.red
                                : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                          if (comment.likesCount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '${comment.likesCount}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onReply,
                      child: Text(
                        'Reply',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Added reply to comment feature
