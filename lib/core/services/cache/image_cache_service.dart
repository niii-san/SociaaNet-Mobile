import 'dart:collection';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  final LinkedHashMap<String, dynamic> _cache = LinkedHashMap();
  static const int _maxSize = 100;

  void put(String key, dynamic value) {
    if (_cache.length >= _maxSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }

  dynamic get(String key) => _cache[key];

  void clear() => _cache.clear();

  bool containsKey(String key) => _cache.containsKey(key);
}

// Added cache size monitoring
