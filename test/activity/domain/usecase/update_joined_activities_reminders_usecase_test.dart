import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';
import 'package:peerpal/activity/domain/usecase/calculate_upcoming_reminder_dates_usecase.dart';
import 'package:peerpal/activity/domain/usecase/has_ios_notification_permission_usecase.dart';
import 'package:peerpal/activity/domain/usecase/schedule_activity_reminder_usecase.dart';
import 'package:peerpal/activity/domain/usecase/update_joined_activities_reminders_usecase.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'update_joined_activities_reminders_usecase_test.mocks.dart';

@GenerateMocks([
  ActivityReminderRepository,
  CalculateUpcomingReminderDatesUseCase,
  IsIOSWithoutNotificationPermissionUseCase,
  ScheduleActivityReminderUseCase,
])
void main() {
  late UpdateJoinedActivitiesRemindersUseCase
      updateJoinedActivitiesRemindersUseCase;
  late MockActivityReminderRepository mockActivityReminderRepository;
  late MockCalculateUpcomingReminderDatesUseCase
      mockFilterUpcomingRemindersUseCase;
  late MockIsIOSWithoutNotificationPermissionUseCase
      mockIsIOSWithoutNotificationPermissionUseCase;
  late MockScheduleActivityReminderUseCase mockScheduleActivityReminderUseCase;

  late Activity testActivity1;
  late Activity testActivity2;

  setUp(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

    mockActivityReminderRepository = MockActivityReminderRepository();
    mockFilterUpcomingRemindersUseCase =
        MockCalculateUpcomingReminderDatesUseCase();
    mockIsIOSWithoutNotificationPermissionUseCase =
        MockIsIOSWithoutNotificationPermissionUseCase();
    mockScheduleActivityReminderUseCase = MockScheduleActivityReminderUseCase();

    updateJoinedActivitiesRemindersUseCase =
        UpdateJoinedActivitiesRemindersUseCase(
            activityReminderRepository: mockActivityReminderRepository,
            filterUpcomingRemindersUseCase: mockFilterUpcomingRemindersUseCase,
            isIOSWithoutNotificationPermission:
                mockIsIOSWithoutNotificationPermissionUseCase,
            scheduleActivityReminderUseCase:
                mockScheduleActivityReminderUseCase);

    testActivity1 = Activity(
        id: "1",
        timestamp: tz.TZDateTime.now(tz.local).toString(),
        name: "Activity 1",
        date: tz.TZDateTime.now(tz.local)
            .add(Duration(days: 2))
            .millisecondsSinceEpoch,
        code: "code1",
        description: "description1",
        creatorId: "creatorId1",
        creatorName: "creatorName1",
        location: null,
        attendeeIds: [],
        invitationIds: [],
        public: true);
    testActivity2 = Activity(
        id: "2",
        timestamp: tz.TZDateTime.now(tz.local).toString(),
        name: "Activity 2",
        date: tz.TZDateTime.now(tz.local)
            .add(Duration(days: 2))
            .millisecondsSinceEpoch,
        code: "code2",
        description: "description2",
        creatorId: "creatorId2",
        creatorName: "creatorName2",
        location: null,
        attendeeIds: [],
        invitationIds: [],
        public: false);
  });

  test('Given permission is not granted, no updates should be performed',
      () async {
    when(mockIsIOSWithoutNotificationPermissionUseCase.call())
        .thenAnswer((_) async => true);
    await updateJoinedActivitiesRemindersUseCase
        .call([testActivity1, testActivity2]);
    verifyNever(
        mockActivityReminderRepository.getJoinedActivityIdsWithReminders());
    verifyNever(mockActivityReminderRepository.cancelActivityReminders(any));
    verifyNever(mockActivityReminderRepository.setActivityReminder(any, any));
    verifyNever(
        mockActivityReminderRepository.setJoinedActivityIdsWithReminders(any));
    verifyNever(mockFilterUpcomingRemindersUseCase.call(any));
  });

  test('Given permission is granted, updates should be performed as expected',
      () async {
    when(mockIsIOSWithoutNotificationPermissionUseCase.call())
        .thenAnswer((_) async => false);
    when(mockActivityReminderRepository.getJoinedActivityIdsWithReminders())
        .thenAnswer((_) async => ['oldId1', 'oldId2']);
    when(mockFilterUpcomingRemindersUseCase.call(any)).thenAnswer(
        (_) async => [tz.TZDateTime.now(tz.local).add(Duration(days: 2))]);
    await updateJoinedActivitiesRemindersUseCase
        .call([testActivity1, testActivity2]);
    verify(mockActivityReminderRepository.getJoinedActivityIdsWithReminders())
        .called(1);
    verify(mockActivityReminderRepository.cancelActivityReminders('oldId1'))
        .called(1);
    verify(mockActivityReminderRepository.cancelActivityReminders('oldId2'))
        .called(1);
    verify(mockActivityReminderRepository.setActivityReminder(
            testActivity1, any))
        .called(1);
    verify(mockActivityReminderRepository.setActivityReminder(
            testActivity2, any))
        .called(1);
    verify(mockActivityReminderRepository
        .setJoinedActivityIdsWithReminders(['1', '2'])).called(1);
  });
}
