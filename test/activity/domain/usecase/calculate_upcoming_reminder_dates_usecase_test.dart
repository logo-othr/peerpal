import 'package:flutter_test/flutter_test.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/usecase/calculate_reminder_dates_usecase.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

  late CalculateUpcomingReminderDatesUseCase calculateReminderDatesUseCase;

  setUp(() {
    calculateReminderDatesUseCase = CalculateUpcomingReminderDatesUseCase();
  });

  test(
      'should return two upcoming reminder dates for an activity with a future date',
      () async {
    // Arrange
    final activity = Activity(
      id: '123',
      name: 'Sample Activity',
      date: tz.TZDateTime.now(tz.local)
          .add(Duration(days: 3))
          .millisecondsSinceEpoch,
    );

    // Act
    final result = await calculateReminderDatesUseCase(activity);

    // Assert
    expect(result, isNotEmpty);
    expect(result.length, 2);
  });

  test(
      'should return one upcoming reminder date for an activity with a date less than a day in the future',
      () async {
    // Arrange
    final activity = Activity(
      id: '123',
      name: 'Sample Activity',
      date: tz.TZDateTime.now(tz.local)
          .add(Duration(hours: 23))
          .millisecondsSinceEpoch,
    );

    // Act
    final result = await calculateReminderDatesUseCase(activity);

    // Assert
    expect(result, isNotEmpty);
    expect(result.length, 1);
  });

  test(
      'should return no upcoming reminder dates for an activity with a past date',
      () async {
    // Arrange
    final activity = Activity(
      id: '123',
      name: 'Sample Activity',
      date: tz.TZDateTime.now(tz.local)
          .subtract(Duration(days: 3))
          .millisecondsSinceEpoch,
    );

    // Act
    final result = await calculateReminderDatesUseCase(activity);

    // Assert
    expect(result, isEmpty);
  });
}
