class StoryModel {
  final String id;
  final String userId;
  final String username;
  final String? avatarUrl;
  final String mediaUrl;
  final String mediaType;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isViewed;

  StoryModel({required this.id, required this.userId, required this.username, this.avatarUrl, required this.mediaUrl, this.mediaType = 'image', required this.createdAt, required this.expiresAt, this.isViewed = false});

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      avatarUrl: json['avatarUrl'],
      mediaUrl: json['mediaUrl'] ?? '',
      mediaType: json['mediaType'] ?? 'image',
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      isViewed: json['isViewed'] ?? false,
    );
  }
}
