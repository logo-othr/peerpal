import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityRepository {

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

  updateActivity(Activity activity) {
    prefs.setString("activity_creation", jsonEncode(activity.toJson()));
  }

  Activity getCurrentActivity() {
    var activity = Activity();
    try {
      var activityMap = jsonDecode(prefs.getString('activity_creation')!);
      activity = Activity.fromJson(activityMap);
    } catch(e) {
      // ToDo: Implement.
    }
    return activity;
  }

  Future<void> postActivity(Activity activity) async {
    //ToDo: use toJson / toMap
    await FirebaseFirestore.instance
        .collection('activities')
        .doc()
        .set(activity.toJson());
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


  Stream<List<Activity>> getPrivateRequestActivitiesForUser(String currentUserId) async* {
    Stream<QuerySnapshot> privateRequestActivityStream = FirebaseFirestore.instance
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

  Stream<List<Activity>> getPrivateJoinedActivitiesForUser(String currentUserId) async* {
    Stream<QuerySnapshot> privateJoinedActivityStream = FirebaseFirestore.instance
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
