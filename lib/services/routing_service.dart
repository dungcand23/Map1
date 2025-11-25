import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import '../models/geo_point.dart';
import '../models/vehicle.dart';
import '../models/route_option.dart';

class RoutingService {
  static final RoutingService _instance = RoutingService._internal();
  factory RoutingService() => _instance;
  RoutingService._internal();

  static const _baseUrl = "https://router.hereapi.com/v8/routes";

  Future<List<RouteOption>> calculateRoutes({
    required List<GeoPoint> stops,
    required Vehicle vehicle,
  }) async {
    if (stops.length < 2) return [];

    if (AppConfig.hereApiKey.isEmpty ||
        AppConfig.hereApiKey == "YOUR_HERE_API_KEY") {
      return [];
    }

    final origin = stops.first;
    final destination = stops.last;
    final vias = stops.sublist(1, stops.length - 1);

    final transportMode = _isTruck(vehicle) ? "truck" : "car";

    final fastest = await _callHere(
      id: "fastest",
      title: "Tuyến nhanh nhất",
      routingMode: "fast",
      origin: origin,
      destination: destination,
      vias: vias,
      transportMode: transportMode,
      description: _isTruck(vehicle)
          ? "Ưu tiên thời gian cho xe tải (HERE Routing)."
          : "Ưu tiên thời gian (HERE Routing).",
    );

    final shortest = await _callHere(
      id: "shortest",
      title: "Tuyến ngắn nhất",
      routingMode: "short",
      origin: origin,
      destination: destination,
      vias: vias,
      transportMode: transportMode,
      description: _isTruck(vehicle)
          ? "Ưu tiên quãng đường cho xe tải (HERE Routing)."
          : "Ưu tiên quãng đường (HERE Routing).",
    );

    final list = <RouteOption>[];
    if (fastest != null) list.add(fastest);
    if (shortest != null) list.add(shortest);

    return list;
  }

  Future<RouteOption?> _callHere({
    required String id,
    required String title,
    required String routingMode,
    required GeoPoint origin,
    required GeoPoint destination,
    required List<GeoPoint> vias,
    required String transportMode,
    required String description,
  }) async {
    final sb = StringBuffer(_baseUrl);
    sb.write("?apikey=${AppConfig.hereApiKey}");
    sb.write("&transportMode=$transportMode");
    sb.write("&routingMode=$routingMode");
    sb.write("&origin=${origin.lat},${origin.lng}");
    sb.write("&destination=${destination.lat},${destination.lng}");
    sb.write("&return=summary");

    for (final v in vias) {
      sb.write("&via=${v.lat},${v.lng}");
    }

    final uri = Uri.parse(sb.toString());
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      return null;
    }

    final data = json.decode(res.body) as Map<String, dynamic>;
    final routes = data['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) return null;

    final sections =
    (routes.first as Map<String, dynamic>)['sections'] as List<dynamic>?;
    if (sections == null || sections.isEmpty) return null;

    final summary =
    (sections.first as Map<String, dynamic>)['summary'] as Map<String, dynamic>?;

    if (summary == null) return null;

    final lengthMeters = (summary['length'] as num?)?.toDouble() ?? 0;
    final durationSec = (summary['duration'] as num?)?.toDouble() ?? 0;

    final distanceKm = lengthMeters / 1000.0;
    final durationMin = durationSec / 60.0;

    return RouteOption(
      id: id,
      title: title,
      distanceText: "${distanceKm.toStringAsFixed(1)} km",
      durationText: "${durationMin.toStringAsFixed(0)} phút",
      description: description,
      distanceMeters: lengthMeters,
      durationSeconds: durationSec,
      // Polyline tạm: nối các stop
      polyline: [
        origin,
        ...vias,
        destination,
      ],
    );
  }

  bool _isTruck(Vehicle v) {
    final s = (v.id + v.name).toLowerCase();
    return s.contains("truck") ||
        s.contains("tải") ||
        s.contains("container") ||
        s.contains("cont");
  }
}
