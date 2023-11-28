class NotificationPermissionException implements Exception {
  final String message;

  NotificationPermissionException(this.message);

  @override
  String toString() {
    return 'NotificationPermissionException: $message';
  }
}
