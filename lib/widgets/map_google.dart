import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/geo_point.dart';
import '../models/route_option.dart';

class MapGoogle extends StatefulWidget {
  final RouteOption? selectedRoute;

  const MapGoogle({super.key, this.selectedRoute});

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  GoogleMapController? _controller;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void didUpdateWidget(covariant MapGoogle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedRoute != oldWidget.selectedRoute) {
      _renderRoute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      initialCameraPosition: const CameraPosition(
        target: LatLng(10.762622, 106.660172),
        zoom: 13,
      ),
      onMapCreated: (c) {
        _controller = c;
        _renderRoute();
      },
      markers: _markers,
      polylines: _polylines,
    );
  }

  void _renderRoute() {
    final route = widget.selectedRoute;
    if (_controller == null || route == null) return;

    final points = route.polyline;
    if (points.isEmpty) return;

    // MARKERS
    final markers = <Marker>{};
    markers.add(
      Marker(
        markerId: const MarkerId("start"),
        position: LatLng(points.first.lat, points.first.lng),
        infoWindow: const InfoWindow(title: "Start"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("end"),
        position: LatLng(points.last.lat, points.last.lng),
        infoWindow: const InfoWindow(title: "End"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // POLYLINE
    final polyline = Polyline(
      polylineId: const PolylineId("route"),
      points: points
          .map((p) => LatLng(p.lat, p.lng))
          .toList(),
      width: 6,
      color: Colors.blue,
    );

    setState(() {
      _markers = markers;
      _polylines = {polyline};
    });

    // CAMERA FIT
    final bounds = _buildBounds(points);
    _controller!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  LatLngBounds _buildBounds(List<GeoPoint> pts) {
    double minLat = pts.first.lat;
    double maxLat = pts.first.lat;
    double minLng = pts.first.lng;
    double maxLng = pts.first.lng;

    for (final p in pts) {
      if (p.lat < minLat) minLat = p.lat;
      if (p.lat > maxLat) maxLat = p.lat;
      if (p.lng < minLng) minLng = p.lng;
      if (p.lng > maxLng) maxLng = p.lng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
