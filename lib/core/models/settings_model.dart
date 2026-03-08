class UserSettings {
  final PrivacySettings privacy;
  final NotificationSettings notifications;
  final AppearanceSettings appearance;
  final FeedSettings feed;
  final SecuritySettings security;

  UserSettings({
    required this.privacy,
    required this.notifications,
    required this.appearance,
    required this.feed,
    SecuritySettings? security,
  }) : security = security ?? SecuritySettings();

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      privacy: PrivacySettings.fromJson(json['privacy'] ?? {}),
      notifications: NotificationSettings.fromJson(json['notifications'] ?? {}),
      appearance: AppearanceSettings.fromJson(json['appearance'] ?? {}),
      feed: FeedSettings.fromJson(json['feed'] ?? {}),
      security: SecuritySettings.fromJson(json['security'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'privacy': privacy.toJson(),
      'notifications': notifications.toJson(),
      'appearance': appearance.toJson(),
      'feed': feed.toJson(),
      'security': security.toJson(),
    };
  }
}

class PrivacySettings {
  final bool privateAccount;
  final String allowMessagesFrom;
  final String allowCommentsFrom;
  final bool showActivityStatus;
  final bool showReadReceipts;
  final List<BlockedUser> blockedUsers;

  PrivacySettings({
    this.privateAccount = false,
    this.allowMessagesFrom = 'everyone',
    this.allowCommentsFrom = 'everyone',
    this.showActivityStatus = true,
    this.showReadReceipts = true,
    this.blockedUsers = const [],
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      privateAccount: json['private_account'] ?? json['is_private_account'] ?? false,
      allowMessagesFrom: json['allow_messages_from'] ?? json['who_can_message'] ?? 'everyone',
      allowCommentsFrom: json['allow_comments_from'] ?? 'everyone',
      showActivityStatus: json['show_activity_status'] ?? true,
      showReadReceipts: json['show_read_receipts'] ?? true,
      blockedUsers: (json['blocked_users'] as List?)
              ?.map((u) => BlockedUser.fromJson(u))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'private_account': privateAccount,
        'allow_messages_from': allowMessagesFrom,
        'allow_comments_from': allowCommentsFrom,
        'show_activity_status': showActivityStatus,
        'show_read_receipts': showReadReceipts,
      };
}

class BlockedUser {
  final String id;
  final String username;
  final String fullName;
  final String? avatarUrl;

  BlockedUser({
    required this.id,
    required this.username,
    required this.fullName,
    this.avatarUrl,
  });

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      avatarUrl: json['avatar_url'],
    );
  }
}

class NotificationSettings {
  final bool likes;
  final bool comments;
  final bool mentions;
  final bool follows;
  final bool messages;
  final bool pushEnabled;
  final bool emailEnabled;

  NotificationSettings({
    this.likes = true,
    this.comments = true,
    this.mentions = true,
    this.follows = true,
    this.messages = true,
    this.pushEnabled = true,
    this.emailEnabled = true,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      likes: json['likes'] ?? json['likes_enabled'] ?? true,
      comments: json['comments'] ?? json['comments_enabled'] ?? true,
      mentions: json['mentions'] ?? true,
      follows: json['follows'] ?? json['follows_enabled'] ?? true,
      messages: json['messages'] ?? json['messages_enabled'] ?? true,
      pushEnabled: json['push_enabled'] ?? true,
      emailEnabled: json['email_enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'likes': likes,
        'comments': comments,
        'mentions': mentions,
        'follows': follows,
        'messages': messages,
        'push_enabled': pushEnabled,
        'email_enabled': emailEnabled,
      };
}

class AppearanceSettings {
  final String theme;
  final String fontSize;
  final bool reducedMotion;

  AppearanceSettings({
    this.theme = 'system',
    this.fontSize = 'medium',
    this.reducedMotion = false,
  });

  factory AppearanceSettings.fromJson(Map<String, dynamic> json) {
    return AppearanceSettings(
      theme: json['theme'] ?? 'system',
      fontSize: json['font_size'] ?? 'medium',
      reducedMotion: json['reduced_motion'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'theme': theme,
        'font_size': fontSize,
        'reduced_motion': reducedMotion,
      };
}

class FeedSettings {
  final String mode;
  final bool showSuggestedPosts;
  final bool autoplayVideos;

  FeedSettings({
    this.mode = 'algorithmic',
    this.showSuggestedPosts = true,
    this.autoplayVideos = true,
  });

  factory FeedSettings.fromJson(Map<String, dynamic> json) {
    return FeedSettings(
      mode: json['mode'] ?? json['default_feed_sort'] ?? 'algorithmic',
      showSuggestedPosts: json['show_suggested_posts'] ?? true,
      autoplayVideos: json['autoplay_videos'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'mode': mode,
        'show_suggested_posts': showSuggestedPosts,
        'autoplay_videos': autoplayVideos,
      };
}

class SecuritySettings {
  final List<SessionInfo> sessions;

  SecuritySettings({this.sessions = const []});

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      sessions: (json['sessions'] as List?)
              ?.map((s) => SessionInfo.fromJson(s))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'sessions': sessions.map((s) => s.toJson()).toList(),
      };
}

class SessionInfo {
  final String sessionId;
  final String? device;
  final String? ip;
  final bool isCurrent;
  final DateTime? lastActive;

  SessionInfo({
    required this.sessionId,
    this.device,
    this.ip,
    this.isCurrent = false,
    this.lastActive,
  });

  factory SessionInfo.fromJson(Map<String, dynamic> json) {
    return SessionInfo(
      sessionId: json['session_id'] ?? json['_id'] ?? '',
      device: json['device'] ?? json['user_agent'],
      ip: json['ip'] ?? json['ip_address'],
      isCurrent: json['is_current'] ?? false,
      lastActive: json['last_active'] != null
          ? DateTime.tryParse(json['last_active'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'device': device,
        'ip': ip,
        'is_current': isCurrent,
        'last_active': lastActive?.toIso8601String(),
      };
}
