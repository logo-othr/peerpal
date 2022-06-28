import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/injection.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:rxdart/rxdart.dart';

part 'activity_feed_event.dart';
part 'activity_feed_state.dart';

class ActivityFeedBloc extends Bloc<ActivityFeedEvent, ActivityFeedState> {
  StreamController<List<Activity>> _publicActivityStreamController =
      new BehaviorSubject();
  StreamController<List<Activity>> _createdActivityStreamController =
      new BehaviorSubject();
  StreamController<List<Activity>> _activityRequestListController =
      new BehaviorSubject();
  StreamController<List<Activity>> _activityJoinedListController =
      new BehaviorSubject();

  var currentUserId = FirebaseAuth.instance.currentUser!.uid;

  ActivityFeedBloc() : super(ActivityFeedState());

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<ActivityFeedState> mapEventToState(ActivityFeedEvent event) async* {
    if (event is LoadActivityFeed) {
      Stream<List<Activity>> publicActivityStream =
          sl<ActivityRepository>().getPublicActivities(currentUserId);
      _publicActivityStreamController.addStream(publicActivityStream);

      Stream<List<Activity>> createdActivityStream =
          sl<ActivityRepository>().getCreatedActivities(currentUserId);
      _createdActivityStreamController.addStream(createdActivityStream);

      Stream<List<Activity>> activityRequestList = sl<ActivityRepository>()
          .getPrivateRequestActivitiesForUser(currentUserId);
      _activityRequestListController.addStream(activityRequestList);

      Stream<List<Activity>> activityJoinedList = sl<ActivityRepository>()
          .getPrivateJoinedActivitiesForUser(currentUserId);
      _activityJoinedListController.addStream(activityJoinedList);

      yield state.copyWith(
        status: ActivityFeedStatus.success,
        publicActivityStream: _publicActivityStreamController.stream,
        createdActivityStream: _createdActivityStreamController.stream,
        activityRequestList: _activityRequestListController.stream,
        activityJoinedList: _activityJoinedListController.stream,
      );
    }
  }

  bool isOwnCreatedActivity(Activity activity) {
    return activity.creatorId == currentUserId;
  }
}
