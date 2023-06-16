import 'package:peerpal/activity/domain/models/activity.dart';

abstract class ActivityRepository {
  /// Takes in an activity [code] as input and returns the corresponding
  /// activity name
  String getActivityNameFromCode(String code);

  /// Generates a list of activity objects that includes all possible
  /// activity names and codes, with the other members left empty."
  List<Activity> loadActivityList();

  /// Update the (local temporary) activity object which is currently being created.
  updateLocalActivity(Activity activity);

  /// Returns the (local temporary) activity object which is currently being created.
  Activity getLocalActivity();

  Future<void> postActivity(Activity activity);

  Future<void> updateActivity(Activity activity);

  /// Adds the currently logged in user to the activity as a participant
  Future<void> joinActivity(Activity activity);

  /// Removes the currently logged in user from the list of participants in the activity.
  Future<void> leaveActivity(Activity activity);

  /// Removes the activity if the currently logged in user is the creator
  Future<void> deleteActivity(Activity activity);

  /// The getCreatedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects marked as public.
  Stream<List<Activity>> getPublicActivities(String currentUserId);

  /// The getCreatedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects where each activity was created by the logged-in user.
  Stream<List<Activity>> getCreatedActivities(String currentUserId);

  /// The getJoinActivityRequests method returns a real-time stream of lists, each containing
  /// [Activity] objects for which the current user has received an invitation and the date is in the future.
  Stream<List<Activity>> getJoinActivityRequests(String currentUserId);

  /// The getJoinedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects where the current user has joined and the activity date
  /// is in the future.
  Stream<List<Activity>> getJoinedActivities(String currentUserId);
}
