import 'package:formz/formz.dart';
import 'package:zxcvbn/zxcvbn.dart';

enum PasswordError { invalid, empty, veryWeak, weak, toShort, toLong }

class PasswordModel extends FormzInput<String, PasswordError> {
  const PasswordModel.pure() : super.pure('');

  const PasswordModel.dirty([String password = '']) : super.dirty(password);

  @override
  PasswordError? validator(String? password) {
    if (password == null) return PasswordError.invalid;

    // Quote: OWASP recommendation, 01.07.2021
    // Source: https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html
    // "Minimum length of the passwords should be enforced by the application.
    // Passwords shorter than 8 characters are considered to be weak
    // (NIST SP800-63B)."
    if (password.length < 8) return PasswordError.toShort;

    // Quote: OWASP recommendation, 01.07.2021
    // Source: https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html
    // "Maximum password length should not be set too low, as it will
    // prevent users from creating passphrases.
    // A common maximum length is 64 characters due to limitations
    // in certain hashing algorithms, as discussed
    // in the Password Storage Cheat Sheet. It is important to set
    // a maximum password length to prevent long password
    // Denial of Service attacks."
    if (password.length > 62) return PasswordError.toLong;

    /// Quote: OWASP recommendation, 01.07.2021
    /// Source: https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html
    /// "Include password strength meter to help users create a more complex
    /// password and block common and previously breached passwords
    /// zxcvbn library can be used for this purpose. (Note that this library
    /// is no longer maintained)
    /// Pwned Passwords is a service where passwords can be checked against
    /// previously breached passwords. You can host it yourself or use API."
    ///
    /// Quote: zxcvb package pub.dev, 01.07.2021:
    /// Source: https://pub.dev/packages/zxcvbn
    /// "zxcvbn is a password strength estimator inspired by password crackers,
    /// developed by DropBox. This project is a Dart port of the original
    /// CoffeeScript, for use in Flutter and other Dart projects."
    final zxcvbn = Zxcvbn();

    /// The result zxcvbn level
    final result = zxcvbn.evaluate(password);

    if (result.score == 0) return PasswordError.veryWeak;

    if (result.score == 1) return PasswordError.weak;

    // The password meets the criteria
    return null;
  }
}
