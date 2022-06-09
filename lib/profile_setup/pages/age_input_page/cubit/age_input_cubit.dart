import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';

part 'age_input_state.dart';

class AgeInputCubit extends Cubit<AgeInputState> {
  AgeInputCubit(this._appUserRepository) : super(AgeInputInitial(10));

  final AppUserRepository _appUserRepository;

  void dataChanged(int selectedAge) {
    emit(AgeInputInitial(selectedAge));
  }

  Future<void> postData() async {
    emit(AgeInputPosting(state.selectedAge));

    var userInformation = await _appUserRepository.getCurrentUserInformation();
    var updatedUserInformation =
        userInformation.copyWith(age: state.selectedAge);
    await _appUserRepository.updateUserInformation(updatedUserInformation);
    emit(AgeInputPosted(state.selectedAge));
  }

  Future<int?>currentAge() async{
    var userInformation =
    await _appUserRepository.getCurrentUserInformation();
    return userInformation.age;
  }
}
