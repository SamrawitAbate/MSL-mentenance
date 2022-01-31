import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
Future<void> getPermision() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }


  
}

  Future<GeoPoint> getUserLocation() async {

 Position currentLocation = await  Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
 GeoPoint     _center = GeoPoint(currentLocation.latitude, currentLocation.longitude);

    return _center;
  }