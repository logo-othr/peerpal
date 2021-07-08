import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/auth_repository.dart';

part 'age_selection_state.dart';

class AgeSelectionCubit extends Cubit<AgeSelectionState> {
  final AuthenticationRepository _authRepository;

  AgeSelectionCubit(this._authRepository) : super(AgeSelectionInitial(20));

  ageSelected(int selectedAge) {
    emit(AgeSelectionInitial(selectedAge));
  }

  Future<void> postAge(int selectedAge) async {
    emit(AgeSelectionPosting(selectedAge));
    await _authRepository.updateAge(selectedAge);
    emit(AgeSelectionPosted(selectedAge));
  }
}
