import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';
import 'package:peerpal/profile_setup/domain/phone_input_page/models/phonenum_model.dart';

part 'phone_input_state.dart';

class PhoneInputCubit extends Cubit<PhoneInputState> {
  final AppUserRepository _authRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  PhoneInputCubit(this._authRepository, this._getAuthenticatedUser)
      : super(PhoneInputInitial(PhoneModel.dirty()));

  void phoneChanged(String phoneNumber) {
    final phone = PhoneModel.dirty(phoneNumber);
    emit(PhoneInputInitial(phone));
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    final phone = PhoneModel.dirty(phoneNumber);
    emit(PhoneInputPosting(phone));
    var userInformation = await _getAuthenticatedUser();
    var updatedUserInformation =
        userInformation.copyWith(phoneNumber: phoneNumber);
    await _authRepository.updateUser(updatedUserInformation);
    emit(PhoneInputPosted(phone));
  }

  Future<String?> currentPhoneNumber() async {
    return (await _getAuthenticatedUser()).phoneNumber;
  }
}
