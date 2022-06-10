import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'profile_overview_state.dart';

class ProfileOverviewCubit extends Cubit<ProfileOverviewState> {
  ProfileOverviewCubit(this.repository, this._getAuthenticatedUser) : super(ProfileOverviewInitial());
  final AppUserRepository repository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  Future<void> loadData() async {
    var appUserInformation = await _getAuthenticatedUser();
    emit(ProfileOverviewLoaded(appUserInformation));
  }

  Future <String?> name() async{
    return (await _getAuthenticatedUser()).name;
}

  Future <String?> age() async{
    return (await _getAuthenticatedUser()).age.toString();
  }

  Future <String?> phoneNumber() async{
    return (await _getAuthenticatedUser()).phoneNumber;
  }

  Future <String?> profilePicture() async{
    return (await _getAuthenticatedUser()).imagePath;
  }

}
