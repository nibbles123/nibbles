import 'dart:math';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nibbles/controllers/auth_controller.dart';

import 'geo_locator.dart';

class CurrentLocationService {
  final geoLocationService = GeoLocatorService();
  Position? currentLocation;
  double? locationLat;
  double? locationLng;

  Future<void> setCurrentLocation() async {
    final authCont = Get.find<AuthController>();

    currentLocation = await geoLocationService.getCurrentLocation();
    locationLat = currentLocation!.latitude;
    locationLng = currentLocation!.longitude;
    authCont.userLat.value = currentLocation!.latitude;
    authCont.userLng.value = currentLocation!.longitude;

    print("Hello $locationLat and $locationLng");
  }

  //DISTANCE CALCULATE METHOD
  double distance(
      double lat1, double lon1, double lat2, double lon2, String unit) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    if (unit == 'K') {
      dist = dist * 1.609344;
    } else if (unit == 'N') {
      dist = dist * 0.8684;
    }
    return dist;
  }

  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }
}
