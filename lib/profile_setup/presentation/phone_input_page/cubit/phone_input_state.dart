part of 'phone_input_cubit.dart';

@immutable
abstract class PhoneInputState extends Equatable {
  final PhoneModel phoneNumber;

  const PhoneInputState(this.phoneNumber);
}

class PhoneInputInitial extends PhoneInputState {
  PhoneInputInitial(PhoneModel phoneNumber) : super(phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class PhoneInputPosting extends PhoneInputState {
  PhoneInputPosting(PhoneModel phoneNumber) : super(phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class PhoneInputPosted extends PhoneInputState {
  PhoneInputPosted(PhoneModel phoneNumber) : super(phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class PhoneInputError extends PhoneInputState {
  final String message;

  PhoneInputError(this.message, PhoneModel phone) : super(phone);

  @override
  List<Object?> get props => [phoneNumber];
}
