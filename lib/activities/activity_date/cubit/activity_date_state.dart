part of 'activity_date_cubit.dart';

@immutable
abstract class DateInputState extends Equatable {
  final String date;
  final String time;
  final String activityName;
  final String activityCode;

  DateInputState(this.date, this.time, this.activityName, this.activityCode);
}

class DateInputInitial extends DateInputState {
  DateInputInitial(String date, String time) : super(date, time, "", "");

  @override
  List<Object?> get props => [date, time];
}

class DateInputLoaded extends DateInputState {

  DateInputLoaded(String date, String time, String activityName, String activityCode) : super(date, time, activityName, activityCode);

  List<Object?> get props => [date, time, activityName, activityCode];
}

// class DateInputPosting extends DateInputState {}

// class DateInputPosted extends DateInputState {}
