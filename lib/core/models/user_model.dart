import 'post_model.dart';
import 'reel_model.dart';

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

  /// Alias for [id]
  String get userId => id;

  /// Returns a full avatar URL with host prefix if needed
  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    var url = avatarUrl!;
    if (url.contains('localhost')) url = url.replaceAll('localhost', '10.0.2.2');
    if (!url.startsWith('http')) url = 'http://10.0.2.2:8000$url';
    return url;
  }

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

  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    var url = avatarUrl!;
    if (url.contains('localhost')) url = url.replaceAll('localhost', '10.0.2.2');
    if (!url.startsWith('http')) url = 'http://10.0.2.2:8000$url';
    return url;
  }

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

/// Alias for User used in follow request screens
typedef FollowRequest = User;

/// Search result user
class SearchUser {
  final String id;
  final String fullName;
  final String? username;
  final String? avatarUrl;

  SearchUser({
    required this.id,
    required this.fullName,
    this.username,
    this.avatarUrl,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      username: json['username'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
    );
  }

  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    var url = avatarUrl!;
    if (url.contains('localhost')) url = url.replaceAll('localhost', '10.0.2.2');
    if (!url.startsWith('http')) url = 'http://10.0.2.2:8000$url';
    return url;
  }
}

/// Chat friend used in new message sheet
class ChatFriend {
  final String userId;
  final String fullName;
  final String? username;
  final String? avatarUrl;

  ChatFriend({
    required this.userId,
    required this.fullName,
    this.username,
    this.avatarUrl,
  });

  factory ChatFriend.fromJson(Map<String, dynamic> json) {
    return ChatFriend(
      userId: json['_id'] ?? json['user_id'] ?? '',
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      username: json['username'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
    );
  }

  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    var url = avatarUrl!;
    if (url.contains('localhost')) url = url.replaceAll('localhost', '10.0.2.2');
    if (!url.startsWith('http')) url = 'http://10.0.2.2:8000$url';
    return url;
  }
}

/// Full user profile with posts, reels, and reposts
class UserProfile {
  final String id;
  final String fullName;
  final String? username;
  final String? bio;
  final String? avatarUrl;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isPrivate;
  final bool isVerified;
  final String? isFollowing; // 'following', 'requested', or null
  final List<Post> posts;
  final List<Reel> reels;
  final List<Repost> reposts;

  String get userId => id;

  UserProfile({
    required this.id,
    required this.fullName,
    this.username,
    this.bio,
    this.avatarUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isPrivate = false,
    this.isVerified = false,
    this.isFollowing,
    this.posts = const [],
    this.reels = const [],
    this.reposts = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      username: json['username'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
      followersCount: json['followers_count'] ?? json['followersCount'] ?? 0,
      followingCount: json['following_count'] ?? json['followingCount'] ?? 0,
      postsCount: json['posts_count'] ?? json['postsCount'] ?? 0,
      isPrivate: json['is_private_account'] ?? json['is_private'] ?? false,
      isVerified: json['is_verified'] ?? json['isVerified'] ?? false,
      isFollowing: json['is_following'] is String ? json['is_following'] : (json['is_following'] == true ? 'following' : null),
      posts: (json['posts'] as List?)?.map((p) => Post.fromJson(p as Map<String, dynamic>)).toList() ?? [],
      reels: (json['reels'] as List?)?.map((r) => Reel.fromJson(r as Map<String, dynamic>)).toList() ?? [],
      reposts: (json['reposts'] as List?)?.map((r) => Repost.fromJson(r as Map<String, dynamic>)).toList() ?? [],
    );
  }

  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    var url = avatarUrl!;
    if (url.contains('localhost')) url = url.replaceAll('localhost', '10.0.2.2');
    if (!url.startsWith('http')) url = 'http://10.0.2.2:8000$url';
    return url;
  }
}

/// Activity history item
class HistoryItem {
  final String id;
  final String type;
  final String? mediaUrl;
  final String? caption;
  final String? content;
  final String? authorUsername;
  final String createdAt;

  HistoryItem({
    required this.id,
    required this.type,
    this.mediaUrl,
    this.caption,
    this.content,
    this.authorUsername,
    required this.createdAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? 'post',
      mediaUrl: json['media_url'] ?? json['thumbnail_url'],
      caption: json['caption'],
      content: json['content'],
      authorUsername: json['author']?['username'] ?? json['username'],
      createdAt: json['created_at'] ?? json['createdAt'] ?? '',
    );
  }
}

/// Repost item for profile reposts tab
class Repost {
  final String id;
  final Post? post;
  final Reel? reel;
  final String? authorUsername;
  final String? authorFullName;
  final DateTime createdAt;

  String get repostedAt {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  Repost({
    required this.id,
    this.post,
    this.reel,
    this.authorUsername,
    this.authorFullName,
    required this.createdAt,
  });

  factory Repost.fromJson(Map<String, dynamic> json) {
    final author = json['original_author'] ?? json['author'];
    return Repost(
      id: json['_id'] ?? json['id'] ?? '',
      post: json['post'] != null ? Post.fromJson(json['post'] as Map<String, dynamic>) : null,
      reel: json['reel'] != null ? Reel.fromJson(json['reel'] as Map<String, dynamic>) : null,
      authorUsername: author is Map ? author['username'] : json['username'],
      authorFullName: author is Map ? author['full_name'] : json['full_name'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
