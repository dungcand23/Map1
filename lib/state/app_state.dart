import 'package:flutter/material.dart';

import '../models/stop.dart';
import '../models/vehicle.dart';
import '../models/route_option.dart';
import '../models/saved_route.dart';

class AppState {
  final List<Stop> stops;
  final List<Vehicle> vehicles;
  final Vehicle currentVehicle;

  final List<RouteOption> routeOptions;
  final RouteOption? selectedRoute;

  final List<SavedRoute> savedRoutes;

  const AppState({
    required this.stops,
    required this.vehicles,
    required this.currentVehicle,
    required this.routeOptions,
    required this.selectedRoute,
    required this.savedRoutes,
  });

  factory AppState.initial() {
    final vehicles = <Vehicle>[
      const Vehicle(
        id: "car",
        name: "Car",
        icon: Icons.directions_car,
        height: 1.6,
        width: 1.8,
        length: 4.5,
        weight: 1500,
      ),
      const Vehicle(
        id: "motor",
        name: "Motor",
        icon: Icons.two_wheeler,
        height: 1.3,
        width: 0.7,
        length: 2.0,
        weight: 150,
      ),
      const Vehicle(
        id: "truck",
        name: "Truck",
        icon: Icons.local_shipping,
        height: 3.5,
        width: 2.5,
        length: 12.0,
        weight: 24000,
      ),
    ];

    return AppState(
      stops: [
        Stop("Vị trí của bạn"),
        Stop("Chọn điểm đến"),
      ],
      vehicles: vehicles,
      currentVehicle: vehicles.first,
      routeOptions: const [],
      selectedRoute: null,
      savedRoutes: const [],
    );
  }

  AppState copyWith({
    List<Stop>? stops,
    List<Vehicle>? vehicles,
    Vehicle? currentVehicle,
    List<RouteOption>? routeOptions,
    RouteOption? selectedRoute,
    List<SavedRoute>? savedRoutes,
  }) {
    return AppState(
      stops: stops ?? this.stops,
      vehicles: vehicles ?? this.vehicles,
      currentVehicle: currentVehicle ?? this.currentVehicle,
      routeOptions: routeOptions ?? this.routeOptions,
      selectedRoute: selectedRoute ?? this.selectedRoute,
      savedRoutes: savedRoutes ?? this.savedRoutes,
    );
  }
}
