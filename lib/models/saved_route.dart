import 'stop.dart';
import 'vehicle.dart';
import 'route_option.dart';

class SavedRoute {
  final String id;
  final String name;
  final List<Stop> stops;
  final Vehicle vehicle;
  final RouteOption routeOption;
  final DateTime createdAt;

  const SavedRoute({
    required this.id,
    required this.name,
    required this.stops,
    required this.vehicle,
    required this.routeOption,
    required this.createdAt,
  });
}
