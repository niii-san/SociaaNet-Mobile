class User {
  final String id;
  final String fullName;
  final String? username;
  final String emailAddress;
  final String? bio;
  final String? avatarUrl;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isPrivate;
  final bool isVerified;
  final bool isOnline;
  final bool isFollowing;
  final bool isFollowRequestPending;
  final DateTime? lastActiveAt;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.fullName,
    this.username,
    required this.emailAddress,
    this.bio,
    this.avatarUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isPrivate = false,
    this.isVerified = false,
    this.isOnline = false,
    this.isFollowing = false,
    this.isFollowRequestPending = false,
    this.lastActiveAt,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      username: json['username'],
      emailAddress: json['email_address'] ?? json['email'] ?? '',
      bio: json['bio'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
      followersCount: json['followers_count'] ?? json['followersCount'] ?? 0,
      followingCount: json['following_count'] ?? json['followingCount'] ?? 0,
      postsCount: json['posts_count'] ?? json['postsCount'] ?? 0,
      isPrivate: json['is_private_account'] ?? json['is_private'] ?? json['isPrivate'] ?? false,
      isVerified: json['is_verified'] ?? json['isVerified'] ?? false,
      isOnline: json['is_online'] ?? false,
      isFollowing: json['is_following'] ?? false,
      isFollowRequestPending: json['is_follow_request_pending'] ?? false,
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.tryParse(json['last_active_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'full_name': fullName,
      'username': username,
      'email_address': emailAddress,
      'bio': bio,
      'avatar_url': avatarUrl,
      'followers_count': followersCount,
      'following_count': followingCount,
      'posts_count': postsCount,
      'is_private_account': isPrivate,
      'is_verified': isVerified,
      'is_online': isOnline,
      'is_following': isFollowing,
      'is_follow_request_pending': isFollowRequestPending,
    };
  }

  User copyWith({
    String? fullName,
    String? username,
    String? bio,
    String? avatarUrl,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    bool? isPrivate,
    bool? isOnline,
    bool? isFollowing,
    bool? isFollowRequestPending,
  }) {
    return User(
      id: id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      emailAddress: emailAddress,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      isPrivate: isPrivate ?? this.isPrivate,
      isVerified: isVerified,
      isOnline: isOnline ?? this.isOnline,
      isFollowing: isFollowing ?? this.isFollowing,
      isFollowRequestPending: isFollowRequestPending ?? this.isFollowRequestPending,
      lastActiveAt: lastActiveAt,
      createdAt: createdAt,
    );
  }
}

class SuggestedUser {
  final String userId;
  final String fullName;
  final String? username;
  final String? avatarUrl;
  final int mutualFollowers;

  SuggestedUser({
    required this.userId,
    required this.fullName,
    this.username,
    this.avatarUrl,
    this.mutualFollowers = 0,
  });

  factory SuggestedUser.fromJson(Map<String, dynamic> json) {
    return SuggestedUser(
      userId: json['_id'] ?? json['user_id'] ?? '',
      fullName: json['full_name'] ?? '',
      username: json['username'],
      avatarUrl: json['avatar_url'],
      mutualFollowers: json['mutual_followers'] ?? 0,
    );
  }
}
