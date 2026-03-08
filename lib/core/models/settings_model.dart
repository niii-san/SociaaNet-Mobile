class UserSettings {
  final PrivacySettings privacy;
  final NotificationSettings notifications;
  final AppearanceSettings appearance;
  final FeedSettings feed;

  UserSettings({
    required this.privacy,
    required this.notifications,
    required this.appearance,
    required this.feed,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      privacy: PrivacySettings.fromJson(json['privacy'] ?? {}),
      notifications: NotificationSettings.fromJson(json['notifications'] ?? {}),
      appearance: AppearanceSettings.fromJson(json['appearance'] ?? {}),
      feed: FeedSettings.fromJson(json['feed'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'privacy': privacy.toJson(),
      'notifications': notifications.toJson(),
      'appearance': appearance.toJson(),
      'feed': feed.toJson(),
    };
  }
}

class PrivacySettings {
  final bool isPrivateAccount;
  final String whoCanMessage;
  final bool showActivityStatus;
  final bool showReadReceipts;

  PrivacySettings({
    this.isPrivateAccount = false,
    this.whoCanMessage = 'everyone',
    this.showActivityStatus = true,
    this.showReadReceipts = true,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      isPrivateAccount: json['is_private_account'] ?? false,
      whoCanMessage: json['who_can_message'] ?? 'everyone',
      showActivityStatus: json['show_activity_status'] ?? true,
      showReadReceipts: json['show_read_receipts'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'is_private_account': isPrivateAccount,
        'who_can_message': whoCanMessage,
        'show_activity_status': showActivityStatus,
        'show_read_receipts': showReadReceipts,
      };
}

class NotificationSettings {
  final bool pushEnabled;
  final bool emailEnabled;
  final bool likesEnabled;
  final bool commentsEnabled;
  final bool followsEnabled;
  final bool messagesEnabled;

  NotificationSettings({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.likesEnabled = true,
    this.commentsEnabled = true,
    this.followsEnabled = true,
    this.messagesEnabled = true,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushEnabled: json['push_enabled'] ?? true,
      emailEnabled: json['email_enabled'] ?? true,
      likesEnabled: json['likes_enabled'] ?? true,
      commentsEnabled: json['comments_enabled'] ?? true,
      followsEnabled: json['follows_enabled'] ?? true,
      messagesEnabled: json['messages_enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'push_enabled': pushEnabled,
        'email_enabled': emailEnabled,
        'likes_enabled': likesEnabled,
        'comments_enabled': commentsEnabled,
        'follows_enabled': followsEnabled,
        'messages_enabled': messagesEnabled,
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
  final bool showSuggestedPosts;
  final bool autoplayVideos;
  final String defaultFeedSort;

  FeedSettings({
    this.showSuggestedPosts = true,
    this.autoplayVideos = true,
    this.defaultFeedSort = 'latest',
  });

  factory FeedSettings.fromJson(Map<String, dynamic> json) {
    return FeedSettings(
      showSuggestedPosts: json['show_suggested_posts'] ?? true,
      autoplayVideos: json['autoplay_videos'] ?? true,
      defaultFeedSort: json['default_feed_sort'] ?? 'latest',
    );
  }

  Map<String, dynamic> toJson() => {
        'show_suggested_posts': showSuggestedPosts,
        'autoplay_videos': autoplayVideos,
        'default_feed_sort': defaultFeedSort,
      };
}
