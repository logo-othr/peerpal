import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';

part 'age_input_state.dart';

class AgeInputCubit extends Cubit<AgeInputState> {
  AgeInputCubit(this._appUserRepository, this._getAuthenticatedUser)
      : super(AgeInputInitial(10));

  final AppUserRepository _appUserRepository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  void dataChanged(int selectedAge) {
    emit(AgeInputLoaded(selectedAge));
  }

  Future<void> loadData() async {
    var currentUser = await _getAuthenticatedUser();
    emit(AgeInputLoaded(currentUser.age ?? state.selectedAge));
  }

  Future<void> update() async {
    emit(AgeInputPosting(state.selectedAge));

    var userInformation = await _getAuthenticatedUser();
    var updatedUserInformation =
        userInformation.copyWith(age: state.selectedAge);
    await _appUserRepository.updateUser(updatedUserInformation);
    emit(AgeInputPosted(state.selectedAge));
  }

  Future<int?> currentAge() async {
    return (await _getAuthenticatedUser()).age;
  }
}
