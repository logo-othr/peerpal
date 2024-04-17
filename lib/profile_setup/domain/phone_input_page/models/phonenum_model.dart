import 'package:formz/formz.dart';

enum PhoneError { toShort, toLong, minimum }

class PhoneModel extends FormzInput<String, PhoneError> {
  const PhoneModel.pure() : super.pure('');

  const PhoneModel.dirty([String num = '']) : super.dirty(num);

  @override
  PhoneError? validator(String? number) {
    if (number!.length <= 1) {
      return PhoneError.minimum;
    } else if (number!.length < 9 && number!.length > 1) {
      return PhoneError.toShort;
    } else if (number.length > 15) {
      return PhoneError.toLong;
    } else {
      return null;
    }
  }
}
