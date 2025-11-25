class GeoPoint {
  final double lat;
  final double lng;

  const GeoPoint(this.lat, this.lng);

  @override
  String toString() => '$lat,$lng';
}
