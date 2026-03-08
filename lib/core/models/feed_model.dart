import 'post_model.dart';

class FeedResponse {
  final List<FeedPost> posts;
  final bool hasMore;
  final int? caughtUpAtIndex;
  final int page;
  final int total;
  final int totalPages;

  FeedResponse({
    required this.posts,
    this.hasMore = false,
    this.caughtUpAtIndex,
    this.page = 1,
    this.total = 0,
    this.totalPages = 1,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    final postsList = json['posts'] ?? json['items'] ?? [];
    final int currentPage = json['page'] ?? 1;
    final int pages = json['totalPages'] ?? json['total_pages'] ?? 1;

    return FeedResponse(
      posts: (postsList as List)
              .map((p) => FeedPost.fromJson(p))
              .toList(),
      hasMore: json['has_more'] ?? (currentPage < pages),
      caughtUpAtIndex: json['caught_up_at_index'],
      page: currentPage,
      total: json['total'] ?? 0,
      totalPages: pages,
    );
  }
}

class ExploreReel {
  final String id;
  final String? thumbnailUrl;
  final String videoUrl;
  final String userId;
  final String? username;
  final String? fullName;
  final String? userAvatar;
  final int viewsCount;
  final int likesCount;

  ExploreReel({
    required this.id,
    this.thumbnailUrl,
    required this.videoUrl,
    required this.userId,
    this.username,
    this.fullName,
    this.userAvatar,
    this.viewsCount = 0,
    this.likesCount = 0,
  });

  factory ExploreReel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;

    return ExploreReel(
      id: json['_id'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      videoUrl: json['video_url'] ?? '',
      userId: author?['_id'] ?? json['user_id'] ?? '',
      username: author?['username'] ?? json['username'],
      fullName: author?['full_name'] ?? json['full_name'],
      userAvatar: author?['avatar_url'] ?? json['avatar_url'],
      viewsCount: json['views_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
    );
  }
}
