import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'activity_feed_event.dart';
part 'activity_feed_state.dart';

class ActivityFeedBloc extends Bloc<ActivityFeedEvent, ActivityFeedState> {
  ActivityFeedBloc() : super(ActivityFeedInitial());

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<ActivityFeedState> mapEventToState(ActivityFeedEvent event) async* {
    if (event is LoadActivityFeed) {

    }
  }
}
