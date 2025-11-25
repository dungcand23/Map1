import 'geo_point.dart';
import 'vehicle.dart';

class Stop {
  String label;
  GeoPoint? location;
  Vehicle? vehicle; // xe gắn với điểm dừng (có thể null)

  Stop(this.label, {this.location, this.vehicle});

  Stop copyWith({
    String? label,
    GeoPoint? location,
    Vehicle? vehicle,
  }) {
    return Stop(
      label ?? this.label,
      location: location ?? this.location,
      vehicle: vehicle ?? this.vehicle,
    );
  }
}
