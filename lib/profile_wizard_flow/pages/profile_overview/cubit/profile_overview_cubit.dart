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
}
