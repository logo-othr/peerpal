import 'package:formz/formz.dart';

enum UsernameError { invalid }

class UsernameModel extends FormzInput<String, UsernameError> {
  const UsernameModel.pure() : super.pure('');

  const UsernameModel.dirty([String email = '']) : super.dirty(email);

  @override
  UsernameError? validator(String? username) {
    if (username == null || username == '') {
      return UsernameError.invalid;
    } else {
      return null;
    }
  }
}
