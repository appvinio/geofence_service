import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';

abstract class FlutterHmsGmsAvailabilityWrapper {
  const FlutterHmsGmsAvailabilityWrapper();

  Future<bool> get isGmsAvailable;

  Future<bool> get isHmsAvailable;
}

class FlutterHmsGmsAvailabilityWrapperImpl implements FlutterHmsGmsAvailabilityWrapper {
  const FlutterHmsGmsAvailabilityWrapperImpl();

  @override
  Future<bool> get isGmsAvailable => FlutterHmsGmsAvailability.isGmsAvailable;

  @override
  Future<bool> get isHmsAvailable => FlutterHmsGmsAvailability.isHmsAvailable;
}
