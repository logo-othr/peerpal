class SignUpFailure implements Exception {
  SignUpFailure({this.message = 'Fehler bei der Registierung'});

  final String message;
}
