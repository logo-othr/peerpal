import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/data/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityRepository {
  SharedPreferences _prefs;

  ActivityRepository(this._prefs);

  static List<Activity> _activities = [
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

  static String getActivityNameFromCode(String code) {
    final List<Activity> activities = _activities;

    for (Activity a in activities) {
      if (a.code == code && a.name != null) return a.name!;
    }
    return "<Aktivitätsname>";
  }

  Future<List<Activity>> loadActivityList() async {
    final List<Activity> activities = _activities;

    return activities;
  }

  updateLocalActivity(Activity activity) {
    _prefs.setString("activity_creation", jsonEncode(activity.toJson()));
  }

  Activity getCurrentActivity() {
    var activity = Activity();
    try {
      var activityMap = jsonDecode(_prefs.getString('activity_creation')!);
      activity = Activity.fromJson(activityMap);
    } catch (e) {
      // ToDo: Implement.
    }
    return activity;
  }

  Future<void> postActivity(Activity activity) async {
    //ToDo: use toJson / toMap
    await FirebaseFirestore.instance
        .collection('newActivity')
        .doc(activity.id)
        .set(activity.toJson());
  }

  Future<void> updateActivity(Activity activity) async {
    await FirebaseFirestore.instance
        .collection('updateActivity')
        .doc(activity.id)
        .set(activity.toJson());
  }

  Future<void> joinActivity(Activity activity) async {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('joinActivity').doc().set({
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'activityId': activity.id,
      'joiningId': currentUserId,
    });
  }

  Future<void> leaveActivity(Activity activity) async {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('leaveActivity').doc().set({
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'activityId': activity.id,
      'leavingId': currentUserId,
    });
  }

  Future<void> deleteActivity(Activity activity) async {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('deleteActivity').doc().set({
      'userId': currentUserId,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'activityId': activity.id,
    });
  }

  Future<List<Location>> loadLocations() async {
    final jsonData = await rootBundle.loadString('assets/location.json');
    final list = json.decode(jsonData) as List<dynamic>;
    return list.map((e) => Location.fromJson(e)).toList();
  }

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

        /*if(activity.creatorId != currentUserId)*/
        publicActivityList.add(activity);
        //logger.i("PublicActivityStream: $activity");
      });
      publicActivityList.sort((a, b) => a.date!.compareTo(b.date!));

      yield publicActivityList;
    }
  }

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
        //  logger.i("CreatedActivityStream: $activity");
      });
      createdActivityList.sort((a, b) => a.date!.compareTo(b.date!));
      yield createdActivityList;
    }
  }

  // ToDo: Workaround. Refactor.
  List<Activity> _replaceOrAddActivity(List<Activity> activityList, Activity activity) {
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

  List<Activity> sortActivityList(List<Activity> listToSort, String currentUserId) {
    List<Activity> creatorList = [];
    List<Activity> publicList = [];
    List<Activity> sortedList = [];
    for (Activity activty in listToSort) {
      if (activty.creatorId == currentUserId)
        creatorList.add(activty);
      else
        publicList.add(activty);
    }
    creatorList.sort((a, b) => b.date!.compareTo(a.date!));
    publicList.sort((a, b) => b.date!.compareTo(a.date!));
    sortedList.addAll(creatorList);
    sortedList.addAll(publicList);

    return sortedList;
  }

  Stream<List<Activity>> getPrivateRequestActivitiesForUser(String currentUserId) async* {
    Stream<QuerySnapshot> privateRequestActivityStream = FirebaseFirestore
        .instance
        .collection('activities')
        .where('invitationIds', arrayContains: currentUserId)
        .where('date', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots();

    List<Activity> privateRequestActivitiesFromUserList = <Activity>[];
    await for (QuerySnapshot querySnapshot in privateRequestActivityStream) {
      privateRequestActivitiesFromUserList.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var activity = Activity.fromJson(documentData);
        privateRequestActivitiesFromUserList.add(activity);
        // logger.i("PrivateRequestActivitiesFromUserStream: $activity");
      });
      privateRequestActivitiesFromUserList
          .sort((a, b) => a.date!.compareTo(b.date!));
      yield privateRequestActivitiesFromUserList;
    }
  }

  Stream<List<Activity>> getPrivateJoinedActivitiesForUser(String currentUserId) async* {
    Stream<QuerySnapshot> privateJoinedActivityStream = FirebaseFirestore
        .instance
        .collection('activities')
        .where('attendeeIds', arrayContains: currentUserId)
        .where('date', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots();

    List<Activity> publicJoinedActivitiesFromUserList = <Activity>[];
    await for (QuerySnapshot querySnapshot in privateJoinedActivityStream) {
      publicJoinedActivitiesFromUserList.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var activity = Activity.fromJson(documentData);
        publicJoinedActivitiesFromUserList.add(activity);
        //   logger.i("PublicJoinedActivitiesFromUserStream: $activity");
      });
      publicJoinedActivitiesFromUserList
          .sort((a, b) => a.date!.compareTo(b.date!));
      yield publicJoinedActivitiesFromUserList;
    }
  }
}
