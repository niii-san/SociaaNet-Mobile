/// Author info embedded in posts, comments, reels
class PostAuthor {
  final String id;
  final String username;
  final String fullName;
  final String? avatarUrl;
  final bool isEmailVerified;

  const PostAuthor({
    required this.id,
    this.username = '',
    required this.fullName,
    this.avatarUrl,
    this.isEmailVerified = false,
  });

  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    var url = avatarUrl!;
    if (url.contains('localhost')) url = url.replaceAll('localhost', '10.0.2.2');
    if (!url.startsWith('http')) url = 'http://10.0.2.2:8000$url';
    return url;
  }
}

class Post {
  final String id;
  final String userId;
  final String? username;
  final String? fullName;
  final String? userAvatar;
  final String? caption;
  final List<String> mediaUrls;
  final String mediaType;
  final List<String> hashtags;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int repostsCount;
  final int viewsCount;
  final String visibility;
  final bool isLiked;
  final bool isSaved;
  final bool isReposted;
  final bool commentsDisabled;
  final bool isSensitiveContent;
  final DateTime createdAt;

  /// Alias for [id]
  String get postId => id;

  /// Author info for display
  PostAuthor get author => PostAuthor(
    id: userId,
    username: username ?? '',
    fullName: fullName ?? '',
    avatarUrl: userAvatar,
  );

  /// Returns a full media URL with host prefix
  static String getFullMediaUrl(String url) {
    if (url.contains('localhost')) url = url.replaceAll('localhost', '10.0.2.2');
    if (!url.startsWith('http')) url = 'http://10.0.2.2:8000$url';
    return url;
  }

  Post({
    required this.id,
    required this.userId,
    this.username,
    this.fullName,
    this.userAvatar,
    this.caption,
    this.mediaUrls = const [],
    this.mediaType = 'image',
    this.hashtags = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.repostsCount = 0,
    this.viewsCount = 0,
    this.visibility = 'public',
    this.isLiked = false,
    this.isSaved = false,
    this.isReposted = false,
    this.commentsDisabled = false,
    this.isSensitiveContent = false,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // Handle nested author object
    final author = json['author'] as Map<String, dynamic>?;

    return Post(
      id: json['_id'] ?? json['id'] ?? '',
      userId: author?['_id'] ?? json['user_id'] ?? json['userId'] ?? '',
      username: author?['username'] ?? json['username'],
      fullName: author?['full_name'] ?? json['full_name'],
      userAvatar: author?['avatar_url'] ?? json['user_avatar'] ?? json['avatar_url'],
      caption: json['caption'],
      mediaUrls: (json['media_urls'] as List?)?.cast<String>() ?? [],
      mediaType: json['media_type'] ?? 'image',
      hashtags: (json['hashtags'] as List?)?.cast<String>() ?? [],
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      sharesCount: json['shares_count'] ?? 0,
      repostsCount: json['reposts_count'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      visibility: json['visibility'] ?? 'public',
      isLiked: json['is_liked'] ?? false,
      isSaved: json['is_saved'] ?? false,
      isReposted: json['is_reposted'] ?? false,
      commentsDisabled: json['comments_disabled'] ?? false,
      isSensitiveContent: json['is_sensitive_content'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'author': {
        '_id': userId,
        'username': username,
        'full_name': fullName,
        'avatar_url': userAvatar,
      },
      'caption': caption,
      'media_urls': mediaUrls,
      'media_type': mediaType,
      'hashtags': hashtags,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'reposts_count': repostsCount,
      'views_count': viewsCount,
      'visibility': visibility,
      'is_liked': isLiked,
      'is_saved': isSaved,
      'is_reposted': isReposted,
      'comments_disabled': commentsDisabled,
      'is_sensitive_content': isSensitiveContent,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Post copyWith({
    String? caption,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? repostsCount,
    int? viewsCount,
    String? visibility,
    bool? isLiked,
    bool? isSaved,
    bool? isReposted,
  }) {
    return Post(
      id: id,
      userId: userId,
      username: username,
      fullName: fullName,
      userAvatar: userAvatar,
      caption: caption ?? this.caption,
      mediaUrls: mediaUrls,
      mediaType: mediaType,
      hashtags: hashtags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      repostsCount: repostsCount ?? this.repostsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      visibility: visibility ?? this.visibility,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isReposted: isReposted ?? this.isReposted,
      commentsDisabled: commentsDisabled,
      isSensitiveContent: isSensitiveContent,
      createdAt: createdAt,
    );
  }
}

class FeedPost extends Post {
  final String postId;
  final bool isFollowing;

  FeedPost({
    required super.id,
    required this.postId,
    required super.userId,
    super.username,
    super.fullName,
    super.userAvatar,
    super.caption,
    super.mediaUrls,
    super.mediaType,
    super.hashtags,
    super.likesCount,
    super.commentsCount,
    super.sharesCount,
    super.repostsCount,
    super.viewsCount,
    super.visibility,
    super.isLiked,
    super.isSaved,
    super.isReposted,
    super.commentsDisabled,
    super.isSensitiveContent,
    required super.createdAt,
    this.isFollowing = true,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;

    return FeedPost(
      id: json['_id'] ?? json['id'] ?? '',
      postId: json['post_id'] ?? json['_id'] ?? '',
      userId: author?['_id'] ?? json['user_id'] ?? json['userId'] ?? '',
      username: author?['username'] ?? json['username'],
      fullName: author?['full_name'] ?? json['full_name'],
      userAvatar: author?['avatar_url'] ?? json['user_avatar'] ?? json['avatar_url'],
      caption: json['caption'],
      mediaUrls: (json['media_urls'] as List?)?.cast<String>() ?? [],
      mediaType: json['media_type'] ?? 'image',
      hashtags: (json['hashtags'] as List?)?.cast<String>() ?? [],
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      sharesCount: json['shares_count'] ?? 0,
      repostsCount: json['reposts_count'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      visibility: json['visibility'] ?? 'public',
      isLiked: json['is_liked'] ?? false,
      isSaved: json['is_saved'] ?? false,
      isReposted: json['is_reposted'] ?? false,
      commentsDisabled: json['comments_disabled'] ?? false,
      isSensitiveContent: json['is_sensitive_content'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isFollowing: json['is_following'] ?? true,
    );
  }

  factory FeedPost.fromPost(Post p) {
    return FeedPost(
      id: p.id,
      postId: p.id,
      userId: p.userId,
      username: p.username,
      fullName: p.fullName,
      userAvatar: p.userAvatar,
      caption: p.caption,
      mediaUrls: p.mediaUrls,
      mediaType: p.mediaType,
      hashtags: p.hashtags,
      likesCount: p.likesCount,
      commentsCount: p.commentsCount,
      sharesCount: p.sharesCount,
      repostsCount: p.repostsCount,
      viewsCount: p.viewsCount,
      visibility: p.visibility,
      isLiked: p.isLiked,
      isSaved: p.isSaved,
      isReposted: p.isReposted,
      commentsDisabled: p.commentsDisabled,
      isSensitiveContent: p.isSensitiveContent,
      createdAt: p.createdAt,
    );
  }

  @override
  FeedPost copyWith({
    String? caption,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? repostsCount,
    int? viewsCount,
    String? visibility,
    bool? isLiked,
    bool? isSaved,
    bool? isReposted,
  }) {
    return FeedPost(
      id: id,
      postId: postId,
      userId: userId,
      username: username,
      fullName: fullName,
      userAvatar: userAvatar,
      caption: caption ?? this.caption,
      mediaUrls: mediaUrls,
      mediaType: mediaType,
      hashtags: hashtags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      repostsCount: repostsCount ?? this.repostsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      visibility: visibility ?? this.visibility,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isReposted: isReposted ?? this.isReposted,
      commentsDisabled: commentsDisabled,
      isSensitiveContent: isSensitiveContent,
      createdAt: createdAt,
      isFollowing: isFollowing,
    );
  }
}

class ExplorePost {
  final String id;
  final String? thumbnailUrl;
  final String mediaType;
  final int likesCount;

  /// Alias for [id]
  String get postId => id;

  /// Alias for [thumbnailUrl]
  String? get mediaUrl => thumbnailUrl;

  ExplorePost({
    required this.id,
    this.thumbnailUrl,
    this.mediaType = 'image',
    this.likesCount = 0,
  });

  factory ExplorePost.fromJson(Map<String, dynamic> json) {
    return ExplorePost(
      id: json['_id'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? (json['media_urls'] as List?)?.firstOrNull,
      mediaType: json['media_type'] ?? 'image',
      likesCount: json['likes_count'] ?? 0,
    );
  }
}
