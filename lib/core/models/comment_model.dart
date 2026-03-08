class Comment {
  final String id;
  final String? postId;
  final String? reelId;
  final String userId;
  final String? username;
  final String? fullName;
  final String? userAvatar;
  final String content;
  final int likesCount;
  final bool isLiked;
  final String? parentId;
  final int repliesCount;
  final DateTime createdAt;

  Comment({
    required this.id,
    this.postId,
    this.reelId,
    required this.userId,
    this.username,
    this.fullName,
    this.userAvatar,
    required this.content,
    this.likesCount = 0,
    this.isLiked = false,
    this.parentId,
    this.repliesCount = 0,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;

    return Comment(
      id: json['_id'] ?? json['id'] ?? '',
      postId: json['post_id'] ?? json['post'],
      reelId: json['reel_id'] ?? json['reel'],
      userId: author?['_id'] ?? json['user_id'] ?? '',
      username: author?['username'] ?? json['username'],
      fullName: author?['full_name'] ?? json['full_name'],
      userAvatar: author?['avatar_url'] ?? json['user_avatar'] ?? json['avatar_url'],
      content: json['content'] ?? '',
      likesCount: json['likes_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      parentId: json['parent_id'] ?? json['parent'],
      repliesCount: json['replies_count'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'post_id': postId,
      'reel_id': reelId,
      'author': {
        '_id': userId,
        'username': username,
        'full_name': fullName,
        'avatar_url': userAvatar,
      },
      'content': content,
      'likes_count': likesCount,
      'is_liked': isLiked,
      'parent_id': parentId,
      'replies_count': repliesCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Comment copyWith({
    int? likesCount,
    bool? isLiked,
    int? repliesCount,
  }) {
    return Comment(
      id: id,
      postId: postId,
      reelId: reelId,
      userId: userId,
      username: username,
      fullName: fullName,
      userAvatar: userAvatar,
      content: content,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      parentId: parentId,
      repliesCount: repliesCount ?? this.repliesCount,
      createdAt: createdAt,
    );
  }
}
