import 'package:flutter_test/flutter_test.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/usecase/sort_activity_list_usecase.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  late SortActivityListUseCase useCase;

  setUp(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
    useCase = SortActivityListUseCase();
  });

  test('SortActivityListUseCase sorts list by creatorId and date', () async {
    // Prepare test data
    var currentDate = tz.TZDateTime.now(tz.local);
    List<Activity> activities = [
      Activity(
          creatorId: '2',
          date: currentDate.subtract(Duration(days: 1)).millisecondsSinceEpoch),
      Activity(
          creatorId: '1',
          date: currentDate.subtract(Duration(days: 2)).millisecondsSinceEpoch),
      Activity(
          creatorId: '1',
          date: currentDate.subtract(Duration(days: 1)).millisecondsSinceEpoch),
      Activity(
          creatorId: '2',
          date: currentDate.subtract(Duration(days: 2)).millisecondsSinceEpoch),
    ];

    // Sort the list
    List<Activity> sortedActivities = await useCase.call(activities, '1');

    // Verify the sort order
    expect(sortedActivities[0].creatorId, '1');
    expect(sortedActivities[0].date,
        currentDate.subtract(Duration(days: 1)).millisecondsSinceEpoch);

    expect(sortedActivities[1].creatorId, '1');
    expect(sortedActivities[1].date,
        currentDate.subtract(Duration(days: 2)).millisecondsSinceEpoch);

    expect(sortedActivities[2].creatorId, '2');
    expect(sortedActivities[2].date,
        currentDate.subtract(Duration(days: 1)).millisecondsSinceEpoch);

    expect(sortedActivities[3].creatorId, '2');
    expect(sortedActivities[3].date,
        currentDate.subtract(Duration(days: 2)).millisecondsSinceEpoch);
  });
}
