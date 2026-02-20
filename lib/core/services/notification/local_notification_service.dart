class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  Future<void> initialize() async {
    // Initialize notification plugin
  }

  Future<void> showNotification({required String title, required String body, String? payload}) async {
    // Display local notification
  }

  Future<void> cancelAll() async {
    // Cancel all notifications
  }
}
