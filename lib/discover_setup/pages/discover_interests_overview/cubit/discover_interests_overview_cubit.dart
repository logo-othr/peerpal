import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/app_user_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/enum/communication_type.dart';
import 'package:peerpal/repository/models/location.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';

part 'discover_interests_overview_state.dart';

class DiscoverInterestsOverviewCubit extends Cubit<DiscoverInterestsOverviewState> {
  DiscoverInterestsOverviewCubit(this.repository) : super(DiscoverInterestsOverviewInitial());
  final AppUserRepository repository;

  Future<void> loadData() async {
    var peerPALUser = await repository.getCurrentUserInformation();
    emit(DiscoverInterestsOverviewLoaded(peerPALUser));
  }


}
