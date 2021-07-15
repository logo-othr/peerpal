import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';

part 'age_selection_state.dart';

class AgeSelectionCubit extends Cubit<AgeSelectionState> {
  final AppUserRepository _authRepository;

  AgeSelectionCubit(this._authRepository) : super(AgeSelectionInitial(20));

  ageSelected(int selectedAge) {
    emit(AgeSelectionInitial(selectedAge));
  }

  Future<void> postAge(int selectedAge) async {
    emit(AgeSelectionPosting(selectedAge));
    var appUser = _authRepository.currentUser;
    await _authRepository.updateUser(appUser.copyWith(age: selectedAge));
    emit(AgeSelectionPosted(selectedAge));
  }
}
