import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/activity/data/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/setup.dart';
import 'package:rxdart/rxdart.dart';

part 'activity_joined_list_event.dart';
part 'activity_joined_list_state.dart';

class ActivityJoinedListBloc
    extends Bloc<ActivityJoinedListEvent, ActivityJoinedListState> {
  StreamController<List<Activity>> _activityJoinedListStreamController =
      new BehaviorSubject();

  var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  ActivityJoinedListBloc() : super(ActivityJoinedListState());

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<ActivityJoinedListState> mapEventToState(
      ActivityJoinedListEvent event) async* {
    if (event is LoadActivityJoinedList) {
      Stream<List<Activity>> activityJoinedListStream =
          sl<ActivityRepository>().getJoinedActivities(currentUserId);
      _activityJoinedListStreamController.addStream(activityJoinedListStream);

      _activityJoinedListStreamController.stream
          .listen((List<Activity> activities) {
        sl<ActivityReminderRepository>()
            .clearAndSetActivityReminders(activities);
      });

      yield state.copyWith(
          status: ActivityJoinedListStatus.success,
          activityJoinedList: _activityJoinedListStreamController.stream);
    }
  }
}
