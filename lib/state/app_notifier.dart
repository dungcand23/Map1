import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/app_config.dart';
import '../models/geo_point.dart';
import '../models/route_option.dart';
import '../models/saved_route.dart';
import '../models/stop.dart';
import '../models/vehicle.dart';
import '../services/routing_service.dart';
import 'app_state.dart';

class AppNotifier extends ChangeNotifier {
  AppState _state = AppState.initial();
  AppState get state => _state;

  final _uuid = const Uuid();

  // ----------------- STOP -----------------

  void updateStop(
      int index, {
        String? label,
        GeoPoint? location,
      }) {
    final stops = [..._state.stops];
    if (index >= stops.length) return;

    final old = stops[index];
    final updated = old.copyWith(
      label: label ?? old.label,
      location: location ?? old.location,
    );
    stops[index] = updated;

    // Nếu là dòng cuối & có text -> thêm dòng mới
    if (index == stops.length - 1) {
      final hasText = (updated.label).trim().isNotEmpty;
      if (hasText) {
        stops.add(Stop("Chọn điểm đến"));
      }
    }

    _state = _state.copyWith(stops: stops);
    notifyListeners();
  }

  // ----------------- VEHICLE -----------------

  void selectVehicle(Vehicle v) {
    _state = _state.copyWith(currentVehicle: v);
    notifyListeners();
  }

  void addVehicle(Vehicle v) {
    final list = [..._state.vehicles, v];
    _state = _state.copyWith(
      vehicles: list,
      currentVehicle: v,
    );
    notifyListeners();
  }

  // ----------------- ROUTING -----------------

  Future<void> generateRoutes() async {
    final validStops =
    _state.stops.where((s) => s.location != null).toList();
    if (validStops.length < 2) return;

    final points = validStops.map((s) => s.location!).toList();

    final routes = await RoutingService().calculateRoutes(
      stops: points,
      vehicle: _state.currentVehicle,
    );

    final fuelPrice = AppConfig.defaultFuelPrice;
    final fuelConsumption = AppConfig.defaultFuelConsumption;

    final enriched = routes.map((r) {
      final distanceKm = r.distanceMeters / 1000.0;
      final fuelLiters = distanceKm * fuelConsumption / 100.0;
      final cost = fuelLiters * fuelPrice;

      return r.copyWith(
        fuelLiters: fuelLiters,
        fuelCost: cost,
      );
    }).toList();

    _state = _state.copyWith(
      routeOptions: enriched,
      selectedRoute: enriched.isNotEmpty ? enriched.first : null,
    );
    notifyListeners();
  }

  void selectRoute(RouteOption r) {
    _state = _state.copyWith(selectedRoute: r);
    notifyListeners();
  }
  // ----------------- STOP VEHICLE (XE THEO ĐIỂM DỪNG) -----------------

  void setStopVehicle(int index, Vehicle vehicle) {
    final stops = [..._state.stops];
    if (index >= stops.length) return;

    final old = stops[index];
    final updated = old.copyWith(vehicle: vehicle);
    stops[index] = updated;

    _state = _state.copyWith(stops: stops);
    notifyListeners();
  }


  // ----------------- SAVE ROUTE -----------------

  void saveCurrentRoute() {
    final route = _state.selectedRoute;
    if (route == null) return;

    final id = _uuid.v4();
    final name = _buildRouteName();

    final saved = SavedRoute(
      id: id,
      name: name,
      stops: List<Stop>.from(_state.stops),
      vehicle: _state.currentVehicle,
      routeOption: route,
      createdAt: DateTime.now(),
    );

    final list = [..._state.savedRoutes, saved];
    _state = _state.copyWith(savedRoutes: list);
    notifyListeners();
  }

  void deleteSavedRoute(SavedRoute r) {
    final list = [..._state.savedRoutes]
      ..removeWhere((e) => e.id == r.id);
    _state = _state.copyWith(savedRoutes: list);
    notifyListeners();
  }

  String _buildRouteName() {
    final labels = _state.stops
        .where((s) => s.label.trim().isNotEmpty)
        .map((s) => s.label.trim())
        .toList();

    if (labels.isEmpty) return "Tuyến không tên";
    if (labels.length == 1) return labels.first;
    return "${labels.first} → ${labels.last}";
  }
}
