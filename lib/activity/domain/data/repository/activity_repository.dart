import 'package:peerpal/activity/domain/models/activity.dart';

abstract class ActivityRepository {
  /// Takes in an activity [code] as input and returns the corresponding
  /// activity name
  String getActivityNameFromCode(String code);

  /// Generates a list of activity objects that includes all possible
  /// activity names and codes, with the other members left empty."
  Future<List<Activity>> loadActivityList();

  /// Update the (local temporary) activity object which is currently being created.
  updateLocalActivity(Activity activity);

  /// Returns the (local temporary) activity object which is currently being created.
  Activity getLocalActivity();

  /// Writes the [activity] to the newActivity collection. The app server
  /// subsequently updates the activity and performs additional actions such as
  /// sending notifications.
  Future<void> postActivity(Activity activity);

  /// Writes the [activity] to the updateActivity collection. The app server
  /// subsequently updates the activity and performs additional actions such as
  /// sending notifications.
  Future<void> updateActivity(Activity activity);

  /// Writes the ID of the [activity] along with the ID of the currently logged-in user of the app
  /// to the joinActivity collection. The app server
  /// then updates the activity with the new user ID and may perform additional actions, such as
  /// sending notifications.
  Future<void> joinActivity(Activity activity);

  /// Writes the ID of the [activity] along with the ID of the currently logged-in user of the app
  /// to the leaveActivity collection. The app server
  /// then removes the user ID from the activity and may perform additional actions, such as
  /// sending notifications.
  Future<void> leaveActivity(Activity activity);

  /// Writes the ID of the [activity] along with the ID of the currently logged-in user of the app
  /// to the deleteActivity collection. The app server
  /// first verifies if the user is logged in, and then deletes the activity and may perform
  /// additional actions, such as sending notifications.
  Future<void> deleteActivity(Activity activity);

  /// The getCreatedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects marked as public.
  /// The activities are sorted by date.
  Stream<List<Activity>> getPublicActivities(String currentUserId);

  /// The getCreatedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects where each activity was created by the logged-in user.
  /// The activities are sorted by date.
  Stream<List<Activity>> getCreatedActivities(String currentUserId);

  /// Sorts a list of [Activity] objects based on the creator and activity date.
  ///
  /// The sortActivityList method takes in a list of [Activity] objects (listToSort) and the ID
  /// of the currently logged-in user (currentUserId). It separates the activities created by the
  /// current user into a creatorList and other public activities into a publicList. Both lists
  /// are sorted in descending order based on the activity date. The sorted lists are combined and
  /// returned, with the activities created by the current user first.
  List<Activity> sortActivityList(
      List<Activity> listToSort, String currentUserId);

  /// The getJoinActivityRequests method returns a real-time stream of lists, each containing
  /// [Activity] objects for which the current user has received an invitation and the date is in the future.
  /// The activities are sorted by date.
  ///
  /// Each activity includes an "invitationIds" property, which holds the IDs of all users invited
  /// to the activity. When a user joins the activity, their ID is removed from the "invitationIds"
  /// by the server and added to the "attendeeIds" field.
  Stream<List<Activity>> getJoinActivityRequests(String currentUserId);

  /// The getJoinedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects where the current user has joined and the activity date
  /// is in the future. The activities are sorted by date.
  Stream<List<Activity>> getJoinedActivities(String currentUserId);
}
