class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  void logEvent(String name, [Map<String, dynamic>? parameters]) {
    // Log analytics event
  }

  void logScreenView(String screenName) {
    logEvent('screen_view', {'screen_name': screenName});
  }

  void logLogin(String method) {
    logEvent('login', {'method': method});
  }

  void logSignUp(String method) {
    logEvent('sign_up', {'method': method});
  }

  void logShare(String contentType, String itemId) {
    logEvent('share', {'content_type': contentType, 'item_id': itemId});
  }
}
