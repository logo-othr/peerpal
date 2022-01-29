import 'package:flutter/material.dart';
import 'package:peerpal/repository/models/activity.dart';

class ActivityRepository {
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

  updateActivity(updatedActivityInformation) {}

  getActivityInformation() {}

  loadLocations() {}
}
