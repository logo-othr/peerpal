import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'profile_overview_state.dart';

class ProfileOverviewCubit extends Cubit<ProfileOverviewState> {
  ProfileOverviewCubit(this.repository) : super(ProfileOverviewInitial());
  final AppUserRepository repository;

  Future<void> loadData() async {
    var appUserInformation = await repository.getCurrentUserInformation();
    emit(ProfileOverviewLoaded(appUserInformation));
  }

  Future <String?> name() async{
    var appUserInformation = await repository.getCurrentUserInformation();
    return appUserInformation.name;
  }

  Future <String?> age() async{
    var appUserInformation = await repository.getCurrentUserInformation();
    return appUserInformation.age.toString();
  }

  Future <String?> phoneNumber() async{
    var appUserInformation = await repository.getCurrentUserInformation();
    return appUserInformation.phoneNumber;
  }

  Future <String?> profilePicture() async{
    var appUserInformation = await repository.getCurrentUserInformation();
    return appUserInformation.imagePath;
  }

}
