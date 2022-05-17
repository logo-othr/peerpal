import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:formz/formz.dart';
import '../models/phonenum_model.dart';

part 'phone_input_state.dart';

class PhoneInputCubit extends Cubit<PhoneInputState> {
  final AppUserRepository _authRepository;

  PhoneInputCubit(this._authRepository) : super(PhoneInputInitial(PhoneModel.dirty()));

  void phoneChanged(String phoneNumber) {
    final phone = PhoneModel.dirty(phoneNumber);
    emit(PhoneInputInitial(phone));
  }



  Future<void> updatePhoneNumber(String phoneNumber) async {
    final phone = PhoneModel.dirty(phoneNumber);
    emit(PhoneInputPosting(phone));
    var userInformation = await _authRepository.getCurrentUserInformation();
    var updatedUserInformation = userInformation.copyWith(phoneNumber: phoneNumber);
    await _authRepository.updateUserInformation(updatedUserInformation);
    emit(PhoneInputPosted(phone));
  }

  Future<String?> currentPhoneNumber() async {
    var userInformation =
    await _authRepository.getCurrentUserInformation();
    return userInformation.phoneNumber;
  }


}
