import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/models/activity.dart';

part 'activity_date_state.dart';

class DateInputCubit extends Cubit<DateInputState> {
  DateInputCubit(this._activityRepository)
      : super(DateInputInitial(DateFormat('dd.MM.yyyy').format(DateTime.now()),
            DateFormat('kk:mm').format(DateTime.now())));

  final ActivityRepository _activityRepository;

  void dataChanged(String selectedDate, String selectedTime) {
    if (state is DateInputLoaded) {
      var currentState = (state as DateInputLoaded);
      emit(DateInputLoaded(selectedDate, selectedTime,
          currentState.activityName, currentState.activityCode));
    } else {
      emit(DateInputInitial(selectedDate, selectedTime));
    }
  }

  Future<void> load() async {
    var activity = await _activityRepository.getCurrentActivity();
    String? formattedDate;
    String? formattedTime;
    if (activity.date != null) {
      formattedDate = DateFormat('dd.MM.yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(activity.date!));
      formattedTime = DateFormat('HH:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(activity.date!));
    }
    emit(DateInputLoaded(
        formattedDate == null ? state.date : formattedDate,
        formattedTime == null ? state.time : formattedTime,
        activity.name!,
        activity.code!));
  }

  Future<Activity> postData() async {
    DateFormat inputFormat = DateFormat("dd.MM.yyyy HH:mm");
    DateTime dt = inputFormat.parse('${state.date} ${state.time}');
    // Timestamp ts = Timestamp.fromDate(dt);
    var activity = await _activityRepository.getCurrentActivity();

    activity = activity.copyWith(date: dt.millisecondsSinceEpoch);
    _activityRepository.updateLocalActivity(activity);
    return activity;
  }
}
