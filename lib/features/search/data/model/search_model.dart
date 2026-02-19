class SearchResult {
  final String id;
  final String type;
  final String title;
  final String? subtitle;
  final String? imageUrl;

  SearchResult({required this.id, required this.type, required this.title, this.subtitle, this.imageUrl});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'user',
      title: json['title'] ?? json['username'] ?? '',
      subtitle: json['subtitle'] ?? json['bio'],
      imageUrl: json['imageUrl'] ?? json['avatarUrl'],
    );
  }
}
