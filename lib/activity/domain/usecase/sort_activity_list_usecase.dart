import 'package:peerpal/activity/domain/models/activity.dart';

class SortActivityListUseCase {
  /// Sorts a list of [Activity] objects based on the creator and activity date.
  ///
  /// The sortActivityList method takes in a list of [Activity] objects (listToSort) and the ID
  /// of the currently logged-in user (currentUserId). It separates the activities created by the
  /// current user into a creatorList and other public activities into a publicList. Both lists
  /// are sorted in descending order based on the activity date. The sorted lists are combined and
  /// returned, with the activities created by the current user first.
  ///
  /// Returns a new [List] of sorted [Activity] objects.
  Future<List<Activity>> call(List<Activity> list, String currentUserId) async {
    return sortActivityList(list, currentUserId);
  }

  List<Activity> sortActivityList(List<Activity> list, String currentUserId) {
    List<Activity> creatorList = [];
    List<Activity> publicList = [];
    List<Activity> sortedList = [];
    for (Activity activity in list) {
      if (activity.creatorId == currentUserId)
        creatorList.add(activity);
      else
        publicList.add(activity);
    }

    // Sort by date
    creatorList.sort((a, b) => b.date!.compareTo(a.date!));
    publicList.sort((a, b) => b.date!.compareTo(a.date!));

    // Combine
    sortedList.addAll(creatorList);
    sortedList.addAll(publicList);

    return sortedList;
  }
}
