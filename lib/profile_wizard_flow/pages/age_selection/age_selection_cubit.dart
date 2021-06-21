import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/profile_wizard_flow/models/profile.dart';
import 'package:peerpal/profile_wizard_flow/repository/data/ages.dart';
import 'package:peerpal/profile_wizard_flow/repository/profile_wizard_repository.dart';
import 'package:peerpal/profile_wizard_flow/repository/user_repository.dart';

part 'age_selection_state.dart';

class AgeSelectionCubit extends Cubit<AgeSelectionState> {
  final AppUserRepository _userRepository;

  AgeSelectionCubit(this._userRepository) : super(AgeSelectionInitial(20));

  ageSelected(int selectedAge) {
    emit(AgeSelectionInitial(selectedAge));
  }



 Future<void> postAge(int selectedAge) async {
    emit(AgeSelectionPosting(selectedAge));
    int updatedAge = await _userRepository.postAge(selectedAge);
    emit(AgeSelectionPosted(updatedAge));
 }

}
