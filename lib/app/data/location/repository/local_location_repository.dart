import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:peerpal/app/domain/location/location_repository.dart';
import 'package:peerpal/data/location.dart';

class LocalLocationRepository implements LocationRepository {
  Future<List<Location>> loadLocations() async {
    final jsonData = await rootBundle.loadString('assets/location.json');
    final list = json.decode(jsonData) as List<dynamic>;
    return list.map((e) => Location.fromJson(e)).toList();
  }
}
