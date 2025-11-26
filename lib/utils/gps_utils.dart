import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> getLocation() async {
  try {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return Future.error('Location Permission Denied');
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Cannot Get Location Permission');
    }
    bool locatoinEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locatoinEnabled) {
      await Geolocator.openLocationSettings();
    } else {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );
      return position;
    }
    return Future.error('Device Location is Disabled');
  } catch (e) {
    if (kDebugMode) {
      print('Something went wrong while fetching position: $e');
    }
    return null;
  }
}
