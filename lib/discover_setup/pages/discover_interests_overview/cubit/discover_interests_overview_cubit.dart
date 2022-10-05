import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/discover_feed/data/repository/app_user_repository.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_communication/domain/get_user_usecase.dart';

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
