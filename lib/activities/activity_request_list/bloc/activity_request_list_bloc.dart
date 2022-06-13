import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:rxdart/rxdart.dart';

part 'activity_request_list_event.dart';
part 'activity_request_list_state.dart';

class ActivityRequestListBloc
    extends Bloc<ActivityRequestListEvent, ActivityRequestListState> {
  StreamController<List<Activity>> _activityRequestListStreamController =
      new BehaviorSubject();

  var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  ActivityRequestListBloc() : super(ActivityRequestListState());

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<ActivityRequestListState> mapEventToState(
      ActivityRequestListEvent event) async* {
    if (event is LoadActivityRequestList) {
      Stream<List<Activity>> activityRequestListStream =
          sl<ActivityRepository>()
              .getPrivateRequestActivitiesForUser(currentUserId);
      _activityRequestListStreamController.addStream(activityRequestListStream);

      yield state.copyWith(
          status: ActivityRequestListStatus.success,
          activityRequestList: _activityRequestListStreamController.stream);
    }
  }
}
