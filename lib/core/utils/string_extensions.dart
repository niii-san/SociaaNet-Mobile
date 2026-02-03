extension StringExtensions on String {
  String get capitalize => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
  String get capitalizeWords => split(' ').map((word) => word.capitalize).join(' ');
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  String get initials {
    final words = trim().split(' ');
    if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
    return isEmpty ? '' : this[0].toUpperCase();
  }
}
