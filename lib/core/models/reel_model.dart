class Reel {
  final String id;
  final String userId;
  final String? username;
  final String? fullName;
  final String? userAvatar;
  final String videoUrl;
  final String? thumbnailUrl;
  final String? caption;
  final String? audioName;
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
  final DateTime createdAt;

  Reel({
    required this.id,
    required this.userId,
    this.username,
    this.fullName,
    this.userAvatar,
    required this.videoUrl,
    this.thumbnailUrl,
    this.caption,
    this.audioName,
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
    required this.createdAt,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;

    return Reel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: author?['_id'] ?? json['user_id'] ?? '',
      username: author?['username'] ?? json['username'],
      fullName: author?['full_name'] ?? json['full_name'],
      userAvatar: author?['avatar_url'] ?? json['user_avatar'] ?? json['avatar_url'],
      videoUrl: json['video_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      caption: json['caption'],
      audioName: json['audio_name'],
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
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'caption': caption,
      'audio_name': audioName,
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
      'created_at': createdAt.toIso8601String(),
    };
  }

  Reel copyWith({
    int? likesCount,
    int? commentsCount,
    int? repostsCount,
    int? viewsCount,
    bool? isLiked,
    bool? isSaved,
    bool? isReposted,
  }) {
    return Reel(
      id: id,
      userId: userId,
      username: username,
      fullName: fullName,
      userAvatar: userAvatar,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      caption: caption,
      audioName: audioName,
      hashtags: hashtags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount,
      repostsCount: repostsCount ?? this.repostsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      visibility: visibility,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isReposted: isReposted ?? this.isReposted,
      createdAt: createdAt,
    );
  }
}
