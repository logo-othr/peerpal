import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';

part 'phone_input_state.dart';

class PhoneInputCubit extends Cubit<PhoneInputState> {
  final AppUserRepository _authRepository;

  PhoneInputCubit(this._authRepository) : super(PhoneInputInitial(''));

  void phoneChanged(String phoneNumber) {
    emit(PhoneInputInitial(phoneNumber));
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    emit(PhoneInputPosting(phoneNumber));
    var userInformation = await _authRepository.getCurrentUserInformation();
    var updatedUserInformation = userInformation.copyWith(phoneNumber: phoneNumber);
    await _authRepository.updateUserInformation(updatedUserInformation);
    emit(PhoneInputPosted(phoneNumber));
  }

  Future<String?> currentPhoneNumber() async {
    var userInformation =
    await _authRepository.getCurrentUserInformation();
    return userInformation.phoneNumber;
  }
}
