import 'package:formz/formz.dart';

enum ConfirmedPasswordError { invalid }

class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordError> {
  const ConfirmedPassword.pure({this.password = ""}) : super.pure("");

  const ConfirmedPassword.dirty({required this.password, String value = ""})
      : super.dirty(value);

  final String password;

  @override
  ConfirmedPasswordError? validator(String? confirmedPassword) {
    return password == confirmedPassword
        ? null
        : ConfirmedPasswordError.invalid;
  }
}
