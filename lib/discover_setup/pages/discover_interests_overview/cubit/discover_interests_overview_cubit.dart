import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/get_user_usecase.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'discover_interests_overview_state.dart';

class DiscoverInterestsOverviewCubit
    extends Cubit<DiscoverInterestsOverviewState> {
  DiscoverInterestsOverviewCubit(this.repository, this._getAuthenticatedUser)
      : super(DiscoverInterestsOverviewInitial());
  final AppUserRepository repository;
  final GetAuthenticatedUser _getAuthenticatedUser;

  Future<void> loadData() async {
    PeerPALUser peerPALUser = await _getAuthenticatedUser();
    emit(DiscoverInterestsOverviewLoaded(peerPALUser));
  }
}
