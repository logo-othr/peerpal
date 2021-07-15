import 'package:formz/formz.dart';

enum ConfirmedPasswordError { invalid }

class ConfirmedPasswordModel
    extends FormzInput<String, ConfirmedPasswordError> {
  const ConfirmedPasswordModel.pure({this.password = ''}) : super.pure('');

  const ConfirmedPasswordModel.dirty(
      {required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  @override
  ConfirmedPasswordError? validator(String? confirmedPassword) {
    return password == confirmedPassword
        ? null
        : ConfirmedPasswordError.invalid;
  }
}
