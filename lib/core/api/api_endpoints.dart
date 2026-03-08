class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
  static const String socketUrl = 'http://10.0.2.2:8000';

  // ==================== Auth ====================
  static const String userLogin = '/auth/login';
  static const String userSignup = '/auth/signup';
  static const String validateSession = '/auth/validate-session';
  static String forgotPasswordOtp(String email) =>
      '/auth/forgot-password-otp/$email';
  static const String changePasswordWithOtp = '/auth/change-password-with-otp';
  static const String changePassword = '/auth/change-password';
  static const String logout = '/auth/logout';

  // ==================== Users ====================
  static const String getUserInfo = '/users/me';
  static const String uploadAvatar = '/users/me/avatar';
  static const String updateBio = '/users/me/bio';
  static const String updateUsername = '/users/me/username';
  static const String updateFullname = '/users/me/fullname';
  static const String searchUsers = '/users/search';
  static const String userActivities = '/users/me/activities';
  static const String userHistoryLikes = '/users/me/history/likes';
  static const String userHistoryComments = '/users/me/history/comments';
  static const String userHistoryWatches = '/users/me/history/watches';
  static const String userHistoryReposts = '/users/me/history/reposts';
  static const String userSaved = '/users/me/saved';
  static String userProfile(String username) => '/users/profile/$username';
  static String userFollowers(String userId) => '/users/$userId/followers';
  static String userFollowing(String userId) => '/users/$userId/following';

  // ==================== Social / Follow ====================
  static String followUser(String followeeId) =>
      '/users/me/$followeeId/follow';
  static String unfollowUser(String followeeId) =>
      '/users/me/$followeeId/follow';
  static String cancelFollowRequest(String followeeId) =>
      '/users/me/$followeeId/follow-request/cancel';
  static String removeFollower(String followerId) =>
      '/users/me/followers/$followerId';
  static const String followRequests = '/users/me/follow-requests';
  static const String followingRequests = '/users/me/following-requests';
  static String acceptFollowRequest(String followerId) =>
      '/users/me/$followerId/follow-request';
  static String rejectFollowRequest(String followerId) =>
      '/users/me/$followerId/follow-request';

  // ==================== Posts ====================
  static String postDetail(String postId) => '/posts/$postId';
  static String postVisibility(String postId) => '/posts/$postId/visibility';
  static String viewPost(String postId) => '/posts/$postId/view';
  static String likePost(String postId) => '/posts/$postId/like';
  static String repostPost(String postId) => '/posts/$postId/repost';
  static String savePost(String postId) => '/posts/$postId/save';
  static String postComments(String postId) => '/posts/$postId/comments';

  // ==================== Reels ====================
  static String reelDetail(String reelId) => '/reels/$reelId';
  static String reelVisibility(String reelId) => '/reels/$reelId/visibility';
  static String viewReel(String reelId) => '/reels/$reelId/view';
  static String likeReel(String reelId) => '/reels/$reelId/like';
  static String repostReel(String reelId) => '/reels/$reelId/repost';
  static String saveReel(String reelId) => '/reels/$reelId/save';
  static String reelComments(String reelId) => '/reels/$reelId/comments';

  // ==================== Comments ====================
  static String replyComment(String commentId) =>
      '/comments/$commentId/reply';
  static String commentReplies(String commentId) =>
      '/comments/$commentId/replies';
  static String likeComment(String commentId) =>
      '/comments/$commentId/like';
  static String deleteComment(String commentId) =>
      '/comments/$commentId';

  // ==================== Chat ====================
  static const String chatUpload = '/chat/upload';
  static const String chatConversations = '/chat/conversations';
  static const String chatConversationsDirect = '/chat/conversations/direct';
  static const String chatConversationsGroup = '/chat/conversations/group';
  static String chatConversation(String conversationId) =>
      '/chat/conversations/$conversationId';
  static String chatMessages(String conversationId) =>
      '/chat/conversations/$conversationId/messages';
  static String chatMarkRead(String conversationId) =>
      '/chat/conversations/$conversationId/read';
  static String chatAddParticipant(String conversationId) =>
      '/chat/conversations/$conversationId/participants';
  static String chatRemoveParticipant(
          String conversationId, String userId) =>
      '/chat/conversations/$conversationId/participants/$userId';
  static String chatRenameGroup(String conversationId) =>
      '/chat/conversations/$conversationId/name';
  static String chatReactMessage(String messageId) =>
      '/chat/messages/$messageId/react';
  static String chatMessageReactions(String messageId) =>
      '/chat/messages/$messageId/reactions';
  static String chatDeleteMessage(String messageId) =>
      '/chat/messages/$messageId';
  static const String chatUnreadCount = '/chat/unread-count';
  static const String chatFriends = '/chat/friends';
  static const String chatUsersActivity = '/chat/users/activity';
  static const String chatMessageRequests = '/chat/message-requests';
  static const String chatMessageRequestsCount =
      '/chat/message-requests/count';
  static String chatAcceptRequest(String conversationId) =>
      '/chat/message-requests/$conversationId/accept';
  static String chatRejectRequest(String conversationId) =>
      '/chat/message-requests/$conversationId/reject';

  // ==================== Feed ====================
  static const String feedHome = '/feed/home';
  static const String feedExplore = '/feed/explore';
  static const String feedReels = '/feed/reels';
  static const String feedSuggestedUsers = '/feed/suggested-users';

  // ==================== Notifications ====================
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsMarkRead = '/notifications/mark-read';
  static String notificationRead(String notificationId) =>
      '/notifications/$notificationId/read';
  static String notificationDetail(String notificationId) =>
      '/notifications/$notificationId';

  // ==================== Reports ====================
  static const String reports = '/reports';

  // ==================== Settings ====================
  static const String settings = '/users/me/settings';
  static const String settingsPrivacy = '/users/me/settings/privacy';
  static const String settingsNotifications =
      '/users/me/settings/notifications';
  static const String settingsAppearance = '/users/me/settings/appearance';
  static const String settingsFeed = '/users/me/settings/feed';

  // ==================== Media (Content Upload) ====================
  static const String mediaPost = '/media/post';
  static const String mediaReel = '/media/reel';

  // ==================== Files ====================
  static String fileImage(String imageKey) => '/files/images/$imageKey';
  static String fileVideo(String videoKey) => '/files/videos/$videoKey';
  static String fileThumbnail(String thumbnailKey) =>
      '/files/thumbnails/$thumbnailKey';
}
