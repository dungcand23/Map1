import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import '../models/place_suggestion.dart';
import '../models/geo_point.dart';

class SearchService {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  static const _baseUrl =
      "https://maps.googleapis.com/maps/api/place";

  Future<List<PlaceSuggestion>> autocomplete(String query) async {
    if (query.trim().isEmpty) return [];

    final key = AppConfig.googlePlacesApiKey;
    if (key.isEmpty || key == "YOUR_GOOGLE_PLACES_API_KEY") {
      return [];
    }

    final uri = Uri.parse(
      "$_baseUrl/autocomplete/json"
          "?input=${Uri.encodeQueryComponent(query)}"
          "&language=vi"
          "&components=country:vn"
          "&key=$key",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) return [];

    final data = json.decode(res.body) as Map<String, dynamic>;
    final status = data['status'] as String?;
    if (status != "OK" && status != "ZERO_RESULTS") return [];

    final list = (data["predictions"] as List<dynamic>? ?? []);
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      return PlaceSuggestion(
        placeId: m['place_id'] as String,
        description: m['description'] as String? ?? '',
      );
    }).toList();
  }

  Future<GeoPoint?> getPlaceLocation(String placeId) async {
    final key = AppConfig.googlePlacesApiKey;
    if (key.isEmpty || key == "YOUR_GOOGLE_PLACES_API_KEY") {
      return null;
    }

    final uri = Uri.parse(
      "$_baseUrl/details/json"
          "?place_id=${Uri.encodeQueryComponent(placeId)}"
          "&fields=geometry"
          "&key=$key",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) return null;

    final data = json.decode(res.body) as Map<String, dynamic>;
    if (data['status'] != 'OK') return null;

    final result = data['result'] as Map<String, dynamic>?;
    final geom = result?['geometry'] as Map<String, dynamic>?;
    final loc = geom?['location'] as Map<String, dynamic>?;

    if (loc == null) return null;

    final lat = (loc['lat'] as num).toDouble();
    final lng = (loc['lng'] as num).toDouble();
    return GeoPoint(lat, lng);
  }
}
