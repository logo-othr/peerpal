import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/domain/repository/activity_repository.dart';
import 'package:peerpal/app_logger.dart';
import 'package:peerpal/setup.dart';
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
  Future<void> close() async {
    await closeStreams();
    return super.close();
  }

  Future<void> closeStreams() async {
    logger.w("Close _publicActivityStreamController");
    // await _publicActivityStreamController.stream.drain();
    await _publicActivityStreamController.close();
    logger.w("Close _createdActivityStreamController");
    //  await _createdActivityStreamController.stream.drain();
    await _createdActivityStreamController.close();
    logger.w("Close _activityRequestListController");
    //  await _activityRequestListController.stream.drain();
    await _activityRequestListController.close();
    logger.w("Close _activityJoinedListController");
    //  await _activityJoinedListController.stream.drain();
    await _activityJoinedListController.close();
  }

  //ToDo: Pass repos via parameters instead of using the service locator
  @override
  Stream<ActivityFeedState> mapEventToState(ActivityFeedEvent event) async* {
    if (event is LoadActivityFeed) {
      Stream<List<Activity>> publicActivityStream =
          sl<ActivityRepository>().getPublicActivities(currentUserId);
      _publicActivityStreamController.addStream(publicActivityStream);

      Stream<List<Activity>> createdActivityStream =
          sl<ActivityRepository>().getCreatedActivities(currentUserId);
      _createdActivityStreamController.addStream(createdActivityStream);

      _createdActivityStreamController.stream
          .listen((List<Activity> activities) {
        sl<ActivityReminderRepository>()
            .setCreatedActivitiesReminders(activities);
      });

      Stream<List<Activity>> activityRequestList =
          sl<ActivityRepository>().getJoinActivityRequests(currentUserId);
      _activityRequestListController.addStream(activityRequestList);

      Stream<List<Activity>> activityJoinedList =
          sl<ActivityRepository>().getJoinedActivities(currentUserId);
      _activityJoinedListController.addStream(activityJoinedList);

      _activityJoinedListController.stream.listen((List<Activity> activities) {
        sl<ActivityReminderRepository>()
            .setJoinedActivitiesReminders(activities);
      });

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
