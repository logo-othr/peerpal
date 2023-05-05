import 'package:peerpal/app/data/location/dto/location.dart';

abstract class LocationRepository {
  Future<List<Location>> loadLocations();
}
