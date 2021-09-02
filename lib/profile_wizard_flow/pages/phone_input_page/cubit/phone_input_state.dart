part of 'phone_input_cubit.dart';

@immutable
abstract class PhoneInputState extends Equatable {
  final String phoneNumber;

  const PhoneInputState(this.phoneNumber);
  
}

class PhoneInputInitial extends PhoneInputState {
  PhoneInputInitial(String phoneNumber) : super(phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class PhoneInputPosting extends PhoneInputState {
  PhoneInputPosting(String phoneNumber) : super(phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class PhoneInputPosted extends PhoneInputState {
  PhoneInputPosted(String phoneNumber) : super(phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class PhoneInputError extends PhoneInputState {
  final String message;

  PhoneInputError(this.message, String phone) : super(phone);

  @override
  List<Object?> get props => [phoneNumber];
}
