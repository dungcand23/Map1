import 'package:flutter/material.dart';
import '../models/geo_point.dart';
import 'dart:math' as math;

class PolylineDecoder {
  static List<GeoPoint> decode(String polyline) {
    List<GeoPoint> result = [];

    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < polyline.length) {
      int shift = 0;
      int b;
      int resultLat = 0;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        resultLat |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      lat += ((resultLat & 1) != 0 ? ~(resultLat >> 1) : (resultLat >> 1));

      shift = 0;
      int resultLng = 0;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        resultLng |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      lng += ((resultLng & 1) != 0 ? ~(resultLng >> 1) : (resultLng >> 1));

      result.add(GeoPoint(lat / 1e5, lng / 1e5));
    }

    return result;
  }
}
