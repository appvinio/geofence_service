import 'package:fl_location/fl_location.dart';
import 'package:geofence_service/location/location_service.dart';
import 'package:geofence_service/location/model/location.dart';
import 'package:geofence_service/location/model/location_accuracy.dart';
import 'package:geofence_service/location/model/location_permission_data.dart';
import 'package:geofence_service/location/model/location_services_status_data.dart';
import 'package:huawei_location/huawei_location.dart' as huawei;

class HmsLocationService extends LocationService {
  final huawei.FusedLocationProviderClient _locationService = huawei.FusedLocationProviderClient();

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
    final huawei.LocationRequest locationRequest = huawei.LocationRequest()
      ..interval = interval
      ..priority = _convertAccuracy(accuracy);

    final code = _locationService.requestLocationUpdates(locationRequest);

    final stream = _locationService.onLocationData?.map((location) {
          final vAccuracy = location.verticalAccuracyMeters ?? 0.0;
          final hAccuracy = location.horizontalAccuracyMeters ?? 0.0;
          final accuracy = vAccuracy > hAccuracy ? vAccuracy : hAccuracy;

          return LocationDataDto(
            latitude: location.latitude ?? 0.0,
            longitude: location.longitude ?? 0.0,
            accuracy: accuracy,
            speed: location.speed ?? 0.0,
            timestamp: DateTime.fromMillisecondsSinceEpoch(location.time?.toInt() ?? 0),
            isMock: false,
          );
        }).asBroadcastStream() ??
        const Stream.empty();

    stream.listen((event) {}, onDone: () async {
      final requestCode = await code;
      if (requestCode != null) {
        _locationService.removeLocationUpdates(requestCode);
      }
    });

    return stream;
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

  int _convertAccuracy(LocationAccuracyData accuracy) {
    switch (accuracy) {
      case LocationAccuracyData.low:
        return huawei.LocationRequest.PRIORITY_LOW_POWER;
      case LocationAccuracyData.high:
        return huawei.LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY;
      case LocationAccuracyData.best:
        return huawei.LocationRequest.PRIORITY_HIGH_ACCURACY;
      case LocationAccuracyData.powerSave:
        return huawei.LocationRequest.PRIORITY_LOW_POWER;
      case LocationAccuracyData.balanced:
        return huawei.LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY;
      case LocationAccuracyData.navigation:
        return huawei.LocationRequest.PRIORITY_HIGH_ACCURACY;
    }
  }
}
