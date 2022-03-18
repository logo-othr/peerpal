import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityRepository {
  static String getActivityNameFromCode(String code) {
    final List<Activity> activities = [];
    activities.add(Activity(code: 'shopping', name: "Einkaufen"));
    activities.add(Activity(code: 'walking', name: "Spazieren"));
    activities.add(Activity(code: 'music', name: "Musik hören"));
    activities.add(Activity(code: 'coffee', name: "Kaffeetrinken"));
    activities.add(Activity(code: 'phone', name: "Telefonieren"));
    activities.add(Activity(code: 'visit', name: "Besuchen"));
    activities.add(Activity(code: 'car', name: "Ausflug mit dem Auto"));
    activities.add(Activity(code: 'tv', name: "Fernsehen schauen"));
    activities.add(Activity(code: 'garden', name: "Gartenarbeit"));
    activities.add(Activity(code: 'cooking', name: "Kochen"));
    activities.add(Activity(code: 'eating', name: "Essen gehen"));
    activities.add(Activity(code: 'travel', name: "Reisen"));
    activities.add(Activity(code: 'sightseeing', name: "Sightseeing"));
    activities.add(Activity(code: 'sport', name: "Sport"));
    activities.add(Activity(code: 'games', name: "Gesellschaftsspiele"));
    activities.add(Activity(code: 'culture', name: "Kultur"));
    activities.add(Activity(code: 'diy', name: "Heimwerken"));
    for (Activity a in activities) {
      if (a.code == code && a.name != null) return a.name!;
    }
    return "<Aktivitätsname>";
  }

  SharedPreferences prefs;

  ActivityRepository(this.prefs);

  Future<List<Activity>> loadActivityList() async {
    final List<Activity> activities = [];
    activities.add(Activity(code: 'shopping', name: "Einkaufen"));
    activities.add(Activity(code: 'walking', name: "Spazieren"));
    activities.add(Activity(code: 'music', name: "Musik hören"));
    activities.add(Activity(code: 'coffee', name: "Kaffeetrinken"));
    activities.add(Activity(code: 'phone', name: "Telefonieren"));
    activities.add(Activity(code: 'visit', name: "Besuchen"));
    activities.add(Activity(code: 'car', name: "Ausflug mit dem Auto"));
    activities.add(Activity(code: 'tv', name: "Fernsehen schauen"));
    activities.add(Activity(code: 'garden', name: "Gartenarbeit"));
    activities.add(Activity(code: 'cooking', name: "Kochen"));
    activities.add(Activity(code: 'eating', name: "Essen gehen"));
    activities.add(Activity(code: 'travel', name: "Reisen"));
    activities.add(Activity(code: 'sightseeing', name: "Sightseeing"));
    activities.add(Activity(code: 'sport', name: "Sport"));
    activities.add(Activity(code: 'games', name: "Gesellschaftsspiele"));
    activities.add(Activity(code: 'culture', name: "Kultur"));
    activities.add(Activity(code: 'diy', name: "Heimwerken"));
    return activities;
  }

  updateLocalActivity(Activity activity) {
    prefs.setString("activity_creation", jsonEncode(activity.toJson()));
  }

  Activity getCurrentActivity() {
    var activity = Activity();
    try {
      var activityMap = jsonDecode(prefs.getString('activity_creation')!);
      activity = Activity.fromJson(activityMap);
    } catch (e) {
      // ToDo: Implement.
    }
    return activity;
  }

  Future<void> postActivity(Activity activity) async {
    //ToDo: use toJson / toMap
    await FirebaseFirestore.instance
        .collection('activities')
        .doc(activity.id)
        .set(activity.toJson());
  }

  Future<void> joinActivity(Activity activity) async {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('joinActivity').doc(
    ).set({
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'activityId': activity.id,
      'joiningId': currentUserId,
      'invitationIds': activity.invitationIds,
    });
  }

  Future<void> leaveActivity(Activity activity) async {
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('leaveActivity').doc(
    ).set({
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'activityId': activity.id,
      'leavingId': currentUserId,
    });
  }

  Future<void> deleteActivity(Activity activity) async {

    await FirebaseFirestore.instance.collection('deleteActivity').doc(
    ).set({
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
        .where('creatorId', isNotEqualTo: currentUserId)
        .orderBy('creatorId')
        .orderBy('date', descending: true)
        .snapshots();

    List<Activity> publicActivityList = <Activity>[];

    await for (QuerySnapshot querySnapshot in publicActivityStream) {
      publicActivityList.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var activity = Activity.fromJson(documentData);



        publicActivityList.add(activity);
        print("PublicActivityStream: $activity");
      });
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
        print("CreatedActivityStream: $activity");
      });
      yield createdActivityList;
    }
  }


  // ToDo: Workaround. Refactor.
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

  List<Activity> sortActivityList(
      List<Activity> listToSort, String currentUserId) {
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

  Stream<List<Activity>> getPrivateRequestActivitiesForUser(
      String currentUserId) async* {
    Stream<QuerySnapshot> privateRequestActivityStream = FirebaseFirestore
        .instance
        .collection('activities')
        .where('invitationIds', arrayContains: currentUserId)
        .orderBy('date', descending: true)
        .snapshots();

    List<Activity> privateRequestActivitiesFromUserList = <Activity>[];
    await for (QuerySnapshot querySnapshot in privateRequestActivityStream) {
      privateRequestActivitiesFromUserList.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var activity = Activity.fromJson(documentData);
        privateRequestActivitiesFromUserList.add(activity);
        print("PrivateRequestActivitiesFromUserStream: $activity");
      });
      yield privateRequestActivitiesFromUserList;
    }
  }

  Stream<List<Activity>> getPrivateJoinedActivitiesForUser(
      String currentUserId) async* {
    Stream<QuerySnapshot> privateJoinedActivityStream = FirebaseFirestore
        .instance
        .collection('activities')
        .where('attendeeIds', arrayContains: currentUserId)
        .orderBy('date', descending: true)
        .snapshots();

    List<Activity> publicJoinedActivitiesFromUserList = <Activity>[];
    await for (QuerySnapshot querySnapshot in privateJoinedActivityStream) {
      publicJoinedActivitiesFromUserList.clear();
      querySnapshot.docs.forEach((document) {
        var documentData = document.data() as Map<String, dynamic>;
        var activity = Activity.fromJson(documentData);
        publicJoinedActivitiesFromUserList.add(activity);
        print("PublicJoinedActivitiesFromUserStream: $activity");
      });
      yield publicJoinedActivitiesFromUserList;
    }
  }
}
