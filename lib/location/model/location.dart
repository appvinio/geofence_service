abstract class LocationData {
  double get latitude;

  double get longitude;

  double get accuracy;

  double get speed;

  DateTime get timestamp;

  bool get isMock;
}

class LocationDataDto implements LocationData {
  LocationDataDto({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speed,
    required this.timestamp,
    required this.isMock,
  });

  @override
  final double latitude;

  @override
  final double longitude;

  @override
  final double accuracy;

  @override
  final double speed;

  @override
  final DateTime timestamp;

  @override
  final bool isMock;

  @override
  bool operator ==(Object other) =>
      other is LocationData &&
      latitude == other.latitude &&
      longitude == other.longitude &&
      accuracy == other.accuracy &&
      speed == other.speed &&
      timestamp == other.timestamp &&
      isMock == other.isMock;

  @override
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      accuracy.hashCode ^
      speed.hashCode ^
      timestamp.hashCode ^
      isMock.hashCode;

  @override
  String toString() {
    return 'LocationDataDto{latitude: $latitude, longitude: $longitude, accuracy: $accuracy, speed: $speed, timestamp: $timestamp, isMock: $isMock}';
  }
}
