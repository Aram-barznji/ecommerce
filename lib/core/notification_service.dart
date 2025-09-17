class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  
  static NotificationService get instance => _instance;
  
  Future<void> init() async {
    // No dependencies - just initialize
    print('Notification service initialized (mock)');
  }
  
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Mock notification - just print for now
    print('Notification: $title - $body');
  }
}