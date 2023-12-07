import 'package:geofence_service/location/model/location.dart';
import 'package:geofence_service/location/model/location_accuracy.dart';
import 'package:geofence_service/location/model/location_permission_data.dart';
import 'package:geofence_service/location/model/location_services_status_data.dart';

abstract class LocationService {
  Future<bool> isLocationServicesEnabled();

  Future<LocationPermissionData> checkLocationPermission();

  Future<LocationPermissionData> requestLocationPermission();

  Stream<LocationData> getLocationStream({
    LocationAccuracyData accuracy = LocationAccuracyData.best,
    int interval = 5000,
  });

  Stream<LocationServicesStatusData> getLocationServicesStatusStream();

  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  );
}
