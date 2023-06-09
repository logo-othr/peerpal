import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/repository/activity_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseActivityRepository implements ActivityRepository {
  SharedPreferences _prefs;

  FirebaseActivityRepository(this._prefs);

  List<Activity> _activities = [
    Activity(code: 'shopping', name: "Ein\u00adkau\u00adfen"),
    Activity(code: 'walking', name: "Spa\u00adzie\u00adren"),
    Activity(code: 'music', name: "Mu\u00adsik hö\u00adren"),
    Activity(code: 'coffee', name: "Kaf\u00adfee\u00adtrin\u00adken"),
    Activity(code: 'phone', name: "Te\u00adle\u00adfo\u00adnie\u00adren"),
    Activity(code: 'visit', name: "Be\u00adsuch\u00aden"),
    Activity(code: 'car', name: "Aus\u00adflug mit dem Au\u00adto"),
    Activity(code: 'tv', name: "Fern\u00adse\u00adhen schau\u00aden"),
    Activity(code: 'garden', name: "Gar\u00adten\u00adar\u00adbeit"),
    Activity(code: 'cooking', name: "Koch\u00aden"),
    Activity(code: 'eating', name: "Es\u00adsen ge\u00adhen"),
    Activity(code: 'goout', name: "Aus\u00adge\u00adhen"),
    Activity(code: 'travel', name: "Rei\u00adsen"),
    Activity(code: 'sightseeing', name: "Sight\u00adseeing"),
    Activity(code: 'sport', name: "Sport"),
    Activity(
        code: 'games', name: "Ge\u00adsell\u00adschafts\u00adspie\u00adle"),
    Activity(code: 'culture', name: "Kul\u00adtur"),
    Activity(code: 'diy', name: "Heim\u00adwer\u00adken"),
    Activity(code: 'other', name: "Sons\u00adti\u00adges")
  ];

  /// Takes in an activity [code] as input and returns the corresponding
  /// activity name
  String getActivityNameFromCode(String code) {
    final List<Activity> activities = _activities;

    for (Activity a in activities) {
      if (a.code == code && a.name != null) return a.name!;
    }
    return "<Aktivitätsname>";
  }

  /// Generates a list of activity objects that includes all possible
  /// activity names and codes, with the other members left empty."
  Future<List<Activity>> loadActivityList() async {
    final List<Activity> activities = _activities;
    return activities;
  }

  /// Update the (local temporary) activity object which is currently being created.
  updateLocalActivity(Activity activity) {
    _prefs.setString("activity_creation", jsonEncode(activity.toJson()));
  }

  /// Returns the (local temporary) activity object which is currently being created.
  Activity getLocalActivity() {
    var activityMap = jsonDecode(_prefs.getString('activity_creation')!);
    Activity activity = Activity.fromJson(activityMap);
    return activity;
  }

  /// Writes the [activity] to the newActivity collection. The app server
  /// subsequently updates the activity and performs additional actions such as
  /// sending notifications.
  Future<void> postActivity(Activity activity) async {
    await FirebaseFirestore.instance
        .collection('newActivity')
        .doc(activity.id)
        .set(activity.toJson());
  }

  /// Writes the [activity] to the updateActivity collection. The app server
  /// subsequently updates the activity and performs additional actions such as
  /// sending notifications.
  Future<void> updateActivity(Activity activity) async {
    await FirebaseFirestore.instance
        .collection('updateActivity')
        .doc(activity.id)
        .set(activity.toJson());
  }

  /// Writes the ID of the [activity] along with the ID of the currently logged-in user of the app
  /// to the joinActivity collection. The app server
  /// then updates the activity with the new user ID and may perform additional actions, such as
  /// sending notifications.
  Future<void> joinActivity(Activity activity) async {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('joinActivity').doc().set({
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'activityId': activity.id,
      'joiningId': currentUserId,
    });
  }

  /// Writes the ID of the [activity] along with the ID of the currently logged-in user of the app
  /// to the leaveActivity collection. The app server
  /// then removes the user ID from the activity and may perform additional actions, such as
  /// sending notifications.
  Future<void> leaveActivity(Activity activity) async {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('leaveActivity').doc().set({
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'activityId': activity.id,
      'leavingId': currentUserId,
    });
  }

  /// Writes the ID of the [activity] along with the ID of the currently logged-in user of the app
  /// to the deleteActivity collection. The app server
  /// first verifies if the user is logged in, and then deletes the activity and may perform
  /// additional actions, such as sending notifications.
  Future<void> deleteActivity(Activity activity) async {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('deleteActivity').doc().set({
      'userId': currentUserId,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'activityId': activity.id,
    });
  }

  /// The getCreatedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects marked as public.
  /// The activities are sorted by date.
  Stream<List<Activity>> getPublicActivities(String currentUserId) async* {
    Stream<QuerySnapshot> publicActivityStream = FirebaseFirestore.instance
        .collection('activities')
        .where('public', isEqualTo: true)
        .where('date', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots();

    List<Activity> publicActivityList = <Activity>[];

    await for (QuerySnapshot querySnapshot in publicActivityStream) {
      publicActivityList.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var activity = Activity.fromJson(documentData);
        publicActivityList.add(activity);
      });
      publicActivityList.sort((a, b) => a.date!.compareTo(b.date!));

      yield publicActivityList;
    }
  }

  /// The getCreatedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects where each activity was created by the logged-in user.
  /// The activities are sorted by date.
  Stream<List<Activity>> getCreatedActivities(String currentUserId) async* {
    Stream<QuerySnapshot> createdActivityStream = FirebaseFirestore.instance
        .collection('activities')
        .where('creatorId', isEqualTo: currentUserId)
        .orderBy('date', descending: true)
        .snapshots();

    List<Activity> createdActivityList = <Activity>[];

    await for (QuerySnapshot querySnapshot in createdActivityStream) {
      createdActivityList.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var activity = Activity.fromJson(documentData);
        createdActivityList.add(activity);
      });
      createdActivityList.sort((a, b) => a.date!.compareTo(b.date!));
      yield createdActivityList;
    }
  }

  @deprecated
  List<Activity> _replaceOrAddActivity(
      List<Activity> activityList, Activity activity) {
    Activity? activityToRemove;
    Activity? activityToAdd;
    bool isReplaced = false;
    for (Activity a in activityList) {
      if (a.id == activity.id) {
        activityToAdd = (activity);
        activityToRemove = a;
        isReplaced = true;
      }
    }
    if (activityToAdd != null) activityList.add(activityToAdd);
    if (activityToRemove != null) activityList.remove(activityToRemove);
    if (!isReplaced) activityList.add(activity);

    return activityList;
  }


  /// The getJoinActivityRequests method returns a real-time stream of lists, each containing
  /// [Activity] objects for which the current user has received an invitation and the date is in the future.
  /// The activities are sorted by date.
  ///
  /// Each activity includes an "invitationIds" property, which holds the IDs of all users invited
  /// to the activity. When a user joins the activity, their ID is removed from the "invitationIds"
  /// by the server and added to the "attendeeIds" field.
  Stream<List<Activity>> getJoinActivityRequests(String currentUserId) async* {
    // Create Stream
    Stream<QuerySnapshot> activitiesWithJoinRequestStream = FirebaseFirestore
        .instance
        .collection('activities')
        .where('invitationIds', arrayContains: currentUserId)
        .where('date', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots();

    List<Activity> activitiesWithJoinRequest = <Activity>[];

    // Await new stream update, clear the list and then yield the new list
    await for (QuerySnapshot querySnapshot in activitiesWithJoinRequestStream) {
      activitiesWithJoinRequest.clear();

      // Parse firebase QuerySnapshot, extract the document data and
      // convert it to a activity object
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        Activity activity = Activity.fromJson(documentData);
        activitiesWithJoinRequest.add(activity);
      });

      // Sort by date
      activitiesWithJoinRequest.sort((a, b) => a.date!.compareTo(b.date!));

      yield activitiesWithJoinRequest;
    }
  }

  /// The getJoinedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects where the current user has joined and the activity date
  /// is in the future. The activities are sorted by date.
  Stream<List<Activity>> getJoinedActivities(String currentUserId) async* {
    Stream<QuerySnapshot> joinedActivitiesStream = FirebaseFirestore.instance
        .collection('activities')
        .where('attendeeIds', arrayContains: currentUserId)
        .where('date', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots();

    List<Activity> joinedActivities = <Activity>[];

    // Await new stream update, clear the list and then yield the new list
    await for (QuerySnapshot querySnapshot in joinedActivitiesStream) {
      joinedActivities.clear();

      // Parse firebase QuerySnapshot, extract the document data and
      // convert it to a activity object
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        Activity activity = Activity.fromJson(documentData);
        joinedActivities.add(activity);
      });

      // Sort by date
      joinedActivities.sort((a, b) => a.date!.compareTo(b.date!));

      yield joinedActivities;
    }
  }
}
