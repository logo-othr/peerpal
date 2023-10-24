import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/domain/models/activity_code.dart';
import 'package:peerpal/activity/domain/repository/activity_repository.dart';
import 'package:peerpal/app/data/firestore/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseActivityRepository implements ActivityRepository {
  static const Map<ActivityCode, String> ActivityNames = {
    ActivityCode.shopping: "Ein\u00adkau\u00adfen",
    ActivityCode.walking: "Spa\u00adzie\u00adren",
    ActivityCode.music: "Mu\u00adsik hö\u00adren",
    ActivityCode.coffee: "Kaf\u00adfee\u00adtrin\u00adken",
    ActivityCode.phone: "Te\u00adle\u00adfo\u00adnie\u00adren",
    ActivityCode.visit: "Be\u00adsuch\u00aden",
    ActivityCode.car: "Aus\u00adflug mit dem Au\u00adto",
    ActivityCode.tv: "Fern\u00adse\u00adhen schau\u00aden",
    ActivityCode.garden: "Gar\u00adten\u00adar\u00adbeit",
    ActivityCode.cooking: "Koch\u00aden",
    ActivityCode.eating: "Es\u00adsen ge\u00adhen",
    ActivityCode.goout: "Aus\u00adge\u00adhen",
    ActivityCode.travel: "Rei\u00adsen",
    ActivityCode.sightseeing: "Sight\u00adseeing",
    ActivityCode.sport: "Sport",
    ActivityCode.games: "Ge\u00adsell\u00adschafts\u00adspie\u00adle",
    ActivityCode.culture: "Kul\u00adtur",
    ActivityCode.diy: "Heim\u00adwer\u00adken",
    ActivityCode.other: "Sons\u00adti\u00adges",
  };

  final SharedPreferences _prefs;
  final FirestoreService _firestoreService;
  final FirebaseAuth _auth;

  FirebaseActivityRepository({
    required SharedPreferences prefs,
    required FirestoreService firestoreService,
    required FirebaseAuth auth,
  })  : _prefs = prefs,
        _firestoreService = firestoreService,
        _auth = auth;

  /// Takes in an activity [code] as input and returns the corresponding
  /// activity name
  String getActivityNameFromCode(String code) {
    ActivityCode activityCode = ActivityCode.values
        .firstWhere((element) => element.toString().split('.').last == code);
    return ActivityNames[activityCode] ?? "<Aktivitätsname>";
  }

  /// Generates a list of activity objects that includes all possible
  /// activity names and codes, with the other members left empty."
  List<Activity> loadActivityList() {
    return ActivityNames.entries
        .map((e) =>
            Activity(code: e.key.toString().split('.').last, name: e.value))
        .toList();
  }

  /// Update the (local temporary) activity object which is currently being created.
  void updateLocalActivity(Activity activity) {
    _prefs.setString("activity_creation", jsonEncode(activity.toJson()));
  }

  /// Returns the (local temporary) activity object which is currently being created.
  Activity getLocalActivity() {
    var activityMap = jsonDecode(_prefs.getString('activity_creation') ?? '{}');
    Activity activity = Activity.fromJson(activityMap);
    return activity;
  }

  /// Writes the [activity] to the newActivity collection. The app server
  /// subsequently updates the activity and performs additional actions such as
  /// sending notifications.
  Future<void> postActivity(Activity activity) async {
    try {
      await _firestoreService.setDocument(
          collection: 'newActivity',
          docId: activity.id!,
          data: activity.toJson());
    } catch (e) {
// TODO: handle exception
    }
  }

  /// Writes the [activity] to the updateActivity collection. The app server
  /// subsequently updates the activity and performs additional actions such as
  /// sending notifications.
  Future<void> updateActivity(Activity activity) async {
    await _firestoreService.setDocument(
        collection: 'updateActivity',
        docId: activity.id!,
        data: activity.toJson());
  }

  /// Writes the ID of the [activity] along with the ID of the currently logged-in user of the app
  /// to the joinActivity collection. The app server
  /// then updates the activity with the new user ID and may perform additional actions, such as
  /// sending notifications.
  Future<void> joinActivity(Activity activity) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId != null) {
      final Map<String, dynamic> data = {
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'activityId': activity.id!,
        'joiningId': currentUserId,
      };
      try {
        await _firestoreService.setDocument(
            collection: 'joinActivity', docId: null, data: data);
      } catch (e) {
        // TODO: Handle exception
      }
    }
  }

  /// Writes the ID of the [activity] along with the ID of the currently logged-in user of the app
  /// to the leaveActivity collection. The app server
  /// then removes the user ID from the activity and may perform additional actions, such as
  /// sending notifications.
  Future<void> leaveActivity(Activity activity) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId != null) {
      final Map<String, dynamic> data = {
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'activityId': activity.id,
        'leavingId': currentUserId,
      };
      try {
        await _firestoreService.setDocument(
            collection: 'leaveActivity', docId: null, data: data);
      } catch (e) {
        // TODO: Handle exception
      }
    }
  }

  /// Writes the ID of the [activity] along with the ID of the currently logged-in user of the app
  /// to the deleteActivity collection. The app server
  /// first verifies if the user is logged in, and then deletes the activity and may perform
  /// additional actions, such as sending notifications.
  Future<void> deleteActivity(Activity activity) async {
    final currentUserId = _auth.currentUser?.uid;

    if (currentUserId != null) {
      final Map<String, dynamic> data = {
        'userId': currentUserId,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'activityId': activity.id,
      };
      try {
        await _firestoreService.setDocument(
            collection: 'deleteActivity', docId: null, data: data);
      } catch (e) {
        // TODO: Handle exception
      }
    }
  }

  /// The getCreatedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects marked as public.
  /// The activities are sorted by date.
  Stream<List<Activity>> getPublicActivities(String currentUserId) {
    return _firestoreService
        .collection('activities')
        .where('public', isEqualTo: true)
        .where('date', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => _snapshotToActivities(snapshot));
  }

  /// The getCreatedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects where each activity was created by the logged-in user.
  /// The activities are sorted by date.
  Stream<List<Activity>> getCreatedActivities(String currentUserId) {
    return _firestoreService
        .collection('activities')
        .where('creatorId', isEqualTo: currentUserId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => _snapshotToActivities(snapshot));
  }

  /// The getJoinActivityRequests method returns a real-time stream of lists, each containing
  /// [Activity] objects for which the current user has received an invitation and the date is in the future.
  /// The activities are sorted by date.
  ///
  /// Each activity includes an "invitationIds" property, which holds the IDs of all users invited
  /// to the activity. When a user joins the activity, their ID is removed from the "invitationIds"
  /// by the server and added to the "attendeeIds" field.
  Stream<List<Activity>> getJoinActivityRequests(String currentUserId) {
    return _firestoreService
        .collection('activities')
        .where('invitationIds', arrayContains: currentUserId)
        .where('date', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => _snapshotToActivities(snapshot));
  }

  /// The getJoinedActivities method returns a real-time stream of lists, each containing
  /// [Activity] objects where the current user has joined and the activity date
  /// is in the future. The activities are sorted by date.
  Stream<List<Activity>> getJoinedActivities(String currentUserId) {
    return _firestoreService
        .collection('activities')
        .where('attendeeIds', arrayContains: currentUserId)
        .where('date', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => _snapshotToActivities(snapshot));
  }

  /// Converts a Firestore query snapshot into a list of activity objects.
  List<Activity> _snapshotToActivities(QuerySnapshot snapshot) {
    return [
      for (final doc in snapshot.docs)
        if (doc.data() is Map<String, dynamic>)
          Activity.fromJson(doc.data() as Map<String, dynamic>)
    ];
  }
}
