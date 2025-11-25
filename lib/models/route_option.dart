import 'geo_point.dart';

class RouteOption {
  final String id;
  final String title;

  final String distanceText;
  final String durationText;
  final String description;

  final double distanceMeters;
  final double durationSeconds;

  final double? fuelLiters;
  final double? fuelCost;

  final List<GeoPoint> polyline;

  const RouteOption({
    required this.id,
    required this.title,
    required this.distanceText,
    required this.durationText,
    required this.description,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.polyline,
    this.fuelLiters,
    this.fuelCost,
  });

  RouteOption copyWith({
    String? id,
    String? title,
    String? distanceText,
    String? durationText,
    String? description,
    double? distanceMeters,
    double? durationSeconds,
    double? fuelLiters,
    double? fuelCost,
    List<GeoPoint>? polyline,
  }) {
    return RouteOption(
      id: id ?? this.id,
      title: title ?? this.title,
      distanceText: distanceText ?? this.distanceText,
      durationText: durationText ?? this.durationText,
      description: description ?? this.description,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      fuelLiters: fuelLiters ?? this.fuelLiters,
      fuelCost: fuelCost ?? this.fuelCost,
      polyline: polyline ?? this.polyline,
    );
  }
}
