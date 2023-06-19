class LoginException implements Exception {
  LoginException({this.message = 'Fehler beim Login.'});

  final String message;
}
