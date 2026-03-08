import 'post_model.dart';

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

  String get reelId => id;

  PostAuthor get author => PostAuthor(
        id: userId,
        username: username ?? '',
        fullName: fullName ?? '',
        avatarUrl: userAvatar,
      );
}

class ReelAuthor {
  final String id;
  final String username;
  final String fullName;
  final String? avatarUrl;

  const ReelAuthor({
    required this.id,
    required this.username,
    required this.fullName,
    this.avatarUrl,
  });

  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    if (avatarUrl!.startsWith('http')) return avatarUrl;
    return 'http://10.0.2.2:8000$avatarUrl';
  }
}

class FeedReel extends Reel {
  FeedReel({
    required super.id,
    required super.userId,
    super.username,
    super.fullName,
    super.userAvatar,
    required super.videoUrl,
    super.thumbnailUrl,
    super.caption,
    super.audioName,
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
    required super.createdAt,
  });

  factory FeedReel.fromJson(Map<String, dynamic> json) {
    final reel = Reel.fromJson(json);
    return FeedReel(
      id: reel.id,
      userId: reel.userId,
      username: reel.username,
      fullName: reel.fullName,
      userAvatar: reel.userAvatar,
      videoUrl: reel.videoUrl,
      thumbnailUrl: reel.thumbnailUrl,
      caption: reel.caption,
      audioName: reel.audioName,
      hashtags: reel.hashtags,
      likesCount: reel.likesCount,
      commentsCount: reel.commentsCount,
      sharesCount: reel.sharesCount,
      repostsCount: reel.repostsCount,
      viewsCount: reel.viewsCount,
      visibility: reel.visibility,
      isLiked: reel.isLiked,
      isSaved: reel.isSaved,
      isReposted: reel.isReposted,
      createdAt: reel.createdAt,
    );
  }

  @override
  PostAuthor get author => PostAuthor(
        id: userId,
        username: username ?? '',
        fullName: fullName ?? '',
        avatarUrl: userAvatar,
      );

  @override
  FeedReel copyWith({
    int? likesCount,
    int? commentsCount,
    int? repostsCount,
    int? viewsCount,
    bool? isLiked,
    bool? isSaved,
    bool? isReposted,
  }) {
    return FeedReel(
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
