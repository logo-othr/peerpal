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
}
