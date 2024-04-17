import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/profile_setup/domain/phone_input_page/models/phonenum_model.dart';

part 'phone_input_state.dart';

class PhoneInputCubit extends Cubit<PhoneInputState> {
  final AppUserRepository _authRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  PhoneInputCubit(this._authRepository, this._getAuthenticatedUser)
      : super(PhoneInputInitial());

  void phoneChanged(String dirtyPhoneNumber) {
    if (state is PhoneInputLoaded) {
      final phoneNumber = PhoneModel.dirty(dirtyPhoneNumber);
      emit(state.copyWith(
        phoneNumber: phoneNumber,
        validationStatus: Formz.validate([phoneNumber]),
      ));
    }
  }

  Future<void> loadData() async {
    var currentUser = await _getAuthenticatedUser();
    emit(PhoneInputLoaded(
      currentUser: currentUser,
      formValidationStatus: state.formValidationStatus,
      phoneNumber: state.phoneNumber,
      errorMessage: state.errorMessage,
    ));
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    final phone = PhoneModel.dirty(phoneNumber);
    emit(state.copyWith(validationStatus: FormzStatus.submissionInProgress));
    var userInformation = await _getAuthenticatedUser();
    var updatedUserInformation =
        userInformation.copyWith(phoneNumber: phoneNumber);
    await _authRepository.updateUser(updatedUserInformation);
    emit(state.copyWith(validationStatus: FormzStatus.submissionSuccess));
  }

  Future<String?> currentPhoneNumber() async {
    return (await _getAuthenticatedUser()).phoneNumber;
  }
}
