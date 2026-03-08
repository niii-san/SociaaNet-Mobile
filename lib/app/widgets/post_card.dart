import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/core/services/post_service.dart';
import 'package:sociaanet/app/widgets/user_avatar.dart';
import 'package:sociaanet/app/widgets/comments_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Reusable Post Card widget matching web client design
class PostCard extends ConsumerStatefulWidget {
  final FeedPost post;
  final Function(FeedPost)? onPostUpdated;

  const PostCard({
    super.key,
    required this.post,
    this.onPostUpdated,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  late FeedPost _post;
  bool _isLiking = false;
  bool _isSaving = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post != oldWidget.post) {
      _post = widget.post;
    }
  }

  String _fixUrl(String url) {
    if (url.contains('localhost')) {
      url = url.replaceAll('localhost', '10.0.2.2');
    }
    if (!url.startsWith('http')) {
      url = 'http://10.0.2.2:8000$url';
    }
    return url;
  }

  Future<void> _toggleLike() async {
    if (_isLiking) return;
    _isLiking = true;

    final wasLiked = _post.isLiked;
    setState(() {
      _post = _post.copyWith(
        isLiked: !wasLiked,
        likesCount: wasLiked ? _post.likesCount - 1 : _post.likesCount + 1,
      );
    });
    widget.onPostUpdated?.call(_post);

    try {
      final service = ref.read(postServiceProvider);
      if (wasLiked) {
        await service.unlikePost(_post.postId);
      } else {
        await service.likePost(_post.postId);
      }
    } catch (_) {
      // Revert on error
      setState(() {
        _post = _post.copyWith(
          isLiked: wasLiked,
          likesCount: wasLiked ? _post.likesCount + 1 : _post.likesCount - 1,
        );
      });
      widget.onPostUpdated?.call(_post);
    } finally {
      _isLiking = false;
    }
  }

  Future<void> _toggleSave() async {
    if (_isSaving) return;
    _isSaving = true;

    final wasSaved = _post.isSaved;
    setState(() {
      _post = _post.copyWith(isSaved: !wasSaved);
    });
    widget.onPostUpdated?.call(_post);

    try {
      final service = ref.read(postServiceProvider);
      if (wasSaved) {
        await service.unsavePost(_post.postId);
      } else {
        await service.savePost(_post.postId);
      }
    } catch (_) {
      setState(() {
        _post = _post.copyWith(isSaved: wasSaved);
      });
      widget.onPostUpdated?.call(_post);
    } finally {
      _isSaving = false;
    }
  }

  Future<void> _toggleRepost() async {
    final wasReposted = _post.isReposted;
    setState(() {
      _post = _post.copyWith(
        isReposted: !wasReposted,
      );
    });
    widget.onPostUpdated?.call(_post);

    try {
      final service = ref.read(postServiceProvider);
      if (wasReposted) {
        await service.unrepostPost(_post.postId);
      } else {
        await service.repostPost(_post.postId);
      }
    } catch (_) {
      setState(() {
        _post = _post.copyWith(
          isReposted: wasReposted,
        );
      });
      widget.onPostUpdated?.call(_post);
    }
  }

  void _openComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsSheet(
        postId: _post.postId,
        type: 'post',
        onCommentAdded: () {
          setState(() {
            _post = _post.copyWith(
              commentsCount: _post.commentsCount + 1,
            );
          });
          widget.onPostUpdated?.call(_post);
        },
      ),
    );
  }

  void _showMoreOptions() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy Link'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.flag_outlined, color: theme.colorScheme.error),
              title: Text('Report', style: TextStyle(color: theme.colorScheme.error)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Username + Time + More
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 8),
            child: Row(
              children: [
                UserAvatar(
                  imageUrl: _post.author.avatarUrl,
                  fallbackName: _post.author.fullName,
                  radius: 18,
                  onTap: () => context.push('/u/${_post.author.username}'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push('/u/${_post.author.username}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _post.author.fullName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_post.author.isEmailVerified) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.verified,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          timeago.format(_post.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, size: 22),
                  onPressed: _showMoreOptions,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ],
            ),
          ),

          // Caption
          if (_post.caption != null && _post.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Text(
                _post.caption!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Images
          if (_post.mediaUrls.isNotEmpty) _buildImageSection(theme),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
            child: Row(
              children: [
                // Like
                _ActionButton(
                  icon: _post.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: _post.isLiked ? Colors.red : null,
                  label: _post.likesCount > 0 ? _formatCount(_post.likesCount) : '',
                  onTap: _toggleLike,
                ),
                // Comment
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: _post.commentsCount > 0
                      ? _formatCount(_post.commentsCount)
                      : '',
                  onTap: _openComments,
                ),
                // Repost
                _ActionButton(
                  icon: Icons.repeat,
                  color: _post.isReposted ? theme.colorScheme.primary : null,
                  label: '',
                  onTap: _toggleRepost,
                ),
                const Spacer(),
                // Save
                IconButton(
                  icon: Icon(
                    _post.isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    size: 22,
                    color: _post.isSaved ? theme.colorScheme.primary : null,
                  ),
                  onPressed: _toggleSave,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ],
            ),
          ),



          Divider(
            height: 0.5,
            thickness: 0.5,
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    if (_post.mediaUrls.length == 1) {
      return GestureDetector(
        onDoubleTap: _toggleLike,
        child: CachedNetworkImage(
          imageUrl: _fixUrl(_post.mediaUrls.first),
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 300,
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (context, url, error) => Container(
            height: 200,
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image, size: 48),
          ),
        ),
      );
    }

    // Multiple images carousel
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: _post.mediaUrls.length,
            onPageChanged: (i) => setState(() => _currentImageIndex = i),
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTap: _toggleLike,
                child: CachedNetworkImage(
                  imageUrl: _fixUrl(_post.mediaUrls[index]),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              );
            },
          ),
          // Image indicator
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _post.mediaUrls.length,
                (i) => Container(
                  width: _currentImageIndex == i ? 8 : 6,
                  height: _currentImageIndex == i ? 8 : 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == i
                        ? theme.colorScheme.primary
                        : Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
          // Counter
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${_post.mediaUrls.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: color ?? theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color ?? theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Added share button to post card
