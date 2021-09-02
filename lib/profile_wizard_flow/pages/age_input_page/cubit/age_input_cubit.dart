import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';

part 'age_input_state.dart';

class AgeInputCubit extends Cubit<AgeInputState> {
  final AppUserRepository _authRepository;

  AgeInputCubit(this._authRepository) : super(AgeInputInitial(20));

  void ageChanged(int selectedAge) {
    emit(AgeInputInitial(selectedAge));
  }

  Future<void> postAge(int selectedAge) async {
    emit(AgeInputPosting(selectedAge));
    var userInformation = await _authRepository.getCurrentUserInformation();

    await _authRepository
        .updateUserInformation(userInformation.copyWith(age: selectedAge));
    emit(AgeInputPosted(selectedAge));
  }
}
