import 'geo_point.dart';

class PlaceSuggestion {
  final String placeId;
  final String description;
  final GeoPoint? location;

  const PlaceSuggestion({
    required this.placeId,
    required this.description,
    this.location,
  });

  PlaceSuggestion copyWith({
    GeoPoint? location,
  }) {
    return PlaceSuggestion(
      placeId: placeId,
      description: description,
      location: location ?? this.location,
    );
  }
}
