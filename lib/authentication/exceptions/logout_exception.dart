class LogoutException implements Exception {
  LogoutException({this.message = 'Fehler beim Ausloggen.'});

  final String message;
}
