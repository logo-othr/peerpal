part of 'phone_input_cubit.dart';

@immutable
abstract class PhoneInputState extends Equatable {
  final FormzStatus formValidationStatus;
  final PhoneModel phoneNumber;
  final String errorMessage;
  final PeerPALUser currentUser;

  const PhoneInputState({
    this.formValidationStatus = FormzStatus.pure,
    this.phoneNumber = const PhoneModel.pure(),
    this.errorMessage = '',
    this.currentUser = PeerPALUser.empty,
  });

  PhoneInputState copyWith({
    FormzStatus? validationStatus,
    PhoneModel? phoneNumber,
    String? errorMessage,
    PeerPALUser? currentUser,
  });

  List<Object> get props => [
        formValidationStatus,
        phoneNumber,
        errorMessage,
        currentUser,
      ];
}

class PhoneInputInitial extends PhoneInputState {
  final FormzStatus formValidationStatus;
  final PhoneModel phoneNumber;
  final String errorMessage;
  final PeerPALUser currentUser;

  PhoneInputInitial(
      {this.formValidationStatus = FormzStatus.pure,
      this.phoneNumber = const PhoneModel.pure(),
      this.errorMessage = '',
      this.currentUser = PeerPALUser.empty})
      : super(
            formValidationStatus: formValidationStatus,
            phoneNumber: phoneNumber,
            errorMessage: errorMessage,
            currentUser: currentUser);

  @override
  List<Object> get props => [
        formValidationStatus,
        phoneNumber,
        errorMessage,
        currentUser,
      ];

  @override
  PhoneInputInitial copyWith(
      {FormzStatus? validationStatus,
      PhoneModel? phoneNumber,
      String? errorMessage,
      PeerPALUser? currentUser}) {
    return PhoneInputInitial(
      formValidationStatus: validationStatus ?? formValidationStatus,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: errorMessage ?? this.errorMessage,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

class PhoneInputLoaded extends PhoneInputState {
  final FormzStatus formValidationStatus;
  final PhoneModel phoneNumber;
  final String errorMessage;
  final PeerPALUser currentUser;

  PhoneInputLoaded(
      {required this.formValidationStatus,
      required this.phoneNumber,
      required this.errorMessage,
      required this.currentUser})
      : super(
            formValidationStatus: formValidationStatus,
            phoneNumber: phoneNumber,
            errorMessage: errorMessage,
            currentUser: currentUser);

  @override
  List<Object> get props => [
        formValidationStatus,
        phoneNumber,
        errorMessage,
        currentUser,
      ];

  @override
  PhoneInputLoaded copyWith(
      {FormzStatus? validationStatus,
      PhoneModel? phoneNumber,
      String? errorMessage,
      PeerPALUser? currentUser}) {
    return PhoneInputLoaded(
      formValidationStatus: validationStatus ?? formValidationStatus,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: errorMessage ?? this.errorMessage,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
