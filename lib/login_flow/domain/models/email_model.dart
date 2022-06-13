import 'package:email_validator/email_validator.dart';
import 'package:formz/formz.dart';

enum EmailError { invalid }

class EmailModel extends FormzInput<String, EmailError> {
  const EmailModel.pure() : super.pure('');

  const EmailModel.dirty([String email = '']) : super.dirty(email);

  @override
  EmailError? validator(String? email) {
    if (email == null || !EmailValidator.validate(email))
      return EmailError.invalid;
    else
      return null;
  }
}
