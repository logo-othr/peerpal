import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_reminder_repository.dart';
import 'package:peerpal/app_logger.dart';
import 'package:timezone/src/date_time.dart';

class ScheduleActivityReminderUseCase {
  final ActivityReminderRepository _reminderRepository;

  ScheduleActivityReminderUseCase(this._reminderRepository);

  Future<void> call(
      Activity activity, TZDateTime reminderDate, String message) async {
    if (await _reminderRepository.reminderExists(activity.id!)) {
      logger.i(
          "Activity reminder for activity id ${activity.id!} is already scheduled");
      // TODO: Cancel and reschedule the reminder
    } else {
      final reminderId = await _reminderRepository.scheduleReminder(
        activity.name!,
        message,
        reminderDate,
      );
      await _reminderRepository.saveReminder(activity.id!, reminderId);
    }
  }
}
