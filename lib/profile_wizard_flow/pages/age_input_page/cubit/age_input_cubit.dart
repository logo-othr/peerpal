import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/user_information.dart';

part 'age_input_state.dart';

class AgeInputCubit extends Cubit<AgeInputState> {
  final AppUserRepository _authRepository;

  AgeInputCubit(this._authRepository) : super(AgeInputInitial(10));

  void ageChanged(int selectedAge) {
    emit(AgeInputInitial(selectedAge));
  }

  Future<void> postAge(int selectedAge) async {
    emit(AgeInputPosting(selectedAge));

    await _authRepository.updateUserInformation(
        Map.from({UserInformationField.userAge: selectedAge}));
    emit(AgeInputPosted(selectedAge));
  }
}
