import 'package:fl_location/fl_location.dart';
import 'package:geofence_service/location/location_service.dart';
import 'package:geofence_service/location/model/location.dart';
import 'package:geofence_service/location/model/location_accuracy.dart';
import 'package:geofence_service/location/model/location_permission_data.dart';
import 'package:geofence_service/location/model/location_services_status_data.dart';

class GmsLocationService extends LocationService {
  @override
  Future<LocationPermissionData> checkLocationPermission() async {
    final permission = await FlLocation.checkLocationPermission();

    return _convertPermission(permission);
  }

  @override
  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return LocationUtils.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  @override
  Stream<LocationServicesStatusData> getLocationServicesStatusStream() {
    return FlLocation.getLocationServicesStatusStream().map((status) {
      switch (status) {
        case LocationServicesStatus.enabled:
          return LocationServicesStatusData.enabled;
        case LocationServicesStatus.disabled:
          return LocationServicesStatusData.disabled;
      }
    });
  }

  @override
  Stream<LocationData> getLocationStream({
    LocationAccuracyData accuracy = LocationAccuracyData.best,
    int interval = 5000,
  }) {
    return FlLocation.getLocationStream(
      accuracy: _convertAccuracy(accuracy),
      interval: interval,
    ).map((location) {
      return LocationDataDto(
        latitude: location.latitude,
        longitude: location.longitude,
        accuracy: location.accuracy,
        speed: location.speed,
        timestamp: location.timestamp,
        isMock: location.isMock,
      );
    });
  }

  @override
  Future<bool> isLocationServicesEnabled() {
    return FlLocation.isLocationServicesEnabled;
  }

  @override
  Future<LocationPermissionData> requestLocationPermission() async {
    final permission = await FlLocation.requestLocationPermission();

    return _convertPermission(permission);
  }

  LocationPermissionData _convertPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
        return LocationPermissionData.always;
      case LocationPermission.whileInUse:
        return LocationPermissionData.whileInUse;
      case LocationPermission.denied:
        return LocationPermissionData.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionData.deniedForever;
    }
  }

  LocationAccuracy _convertAccuracy(LocationAccuracyData accuracy) {
    switch (accuracy) {
      case LocationAccuracyData.low:
        return LocationAccuracy.low;
      case LocationAccuracyData.high:
        return LocationAccuracy.high;
      case LocationAccuracyData.best:
        return LocationAccuracy.best;
      case LocationAccuracyData.powerSave:
        return LocationAccuracy.powerSave;
      case LocationAccuracyData.balanced:
        return LocationAccuracy.balanced;
      case LocationAccuracyData.navigation:
        return LocationAccuracy.navigation;
    }
  }
}
