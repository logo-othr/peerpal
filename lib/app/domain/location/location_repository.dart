import 'package:peerpal/data/location.dart';

abstract class LocationRepository {
  Future<List<Location>> loadLocations();
}
