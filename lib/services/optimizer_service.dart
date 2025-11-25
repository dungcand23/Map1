import '../models/geo_point.dart';
import '../models/stop.dart';
import 'routing_service.dart';

class OptimizerService {
  // Tối ưu thứ tự stop nhưng giữ nguyên điểm đầu
  static Future<List<Stop>> optimizeRoute(List<Stop> stops) async {
    if (stops.length <= 2) return stops;

    // A = start point, fixed
    final start = stops.first;
    final remaining = stops.sublist(1);

    // B1) Nearest Neighbor từ điểm A
    final List<Stop> ordered = [start];
    Stop current = start;
    List<Stop> pool = [...remaining];

    while (pool.isNotEmpty) {
      Stop nearest = pool.first;
      int nearestDist = await RoutingService.getDistanceBetween(
        current.position!,
        nearest.position!,
      );

      for (var s in pool) {
        int dist = await RoutingService.getDistanceBetween(
          current.position!,
          s.position!,
        );
        if (dist < nearestDist) {
          nearestDist = dist;
          nearest = s;
        }
      }

      ordered.add(nearest);
      pool.remove(nearest);
      current = nearest;
    }

    // B2) 2-OPT cải thiện route
    return await _twoOpt(ordered);
  }

  // 2-Opt Improvement
  static Future<List<Stop>> _twoOpt(List<Stop> route) async {
    bool improved = true;

    while (improved) {
      improved = false;

      for (int i = 1; i < route.length - 2; i++) {
        for (int j = i + 1; j < route.length - 1; j++) {
          int distA = await _segmentDistance(route[i - 1], route[i]) +
              await _segmentDistance(route[j], route[j + 1]);

          int distB = await _segmentDistance(route[i - 1], route[j]) +
              await _segmentDistance(route[i], route[j + 1]);

          if (distB < distA) {
            // đảo đoạn i → j
            final newPart = route.sublist(i, j + 1).reversed.toList();
            route.replaceRange(i, j + 1, newPart);
            improved = true;
          }
        }
      }
    }

    return route;
  }

  // Khoảng cách giữa 2 Stop
  static Future<int> _segmentDistance(Stop a, Stop b) async {
    return RoutingService.getDistanceBetween(a.position!, b.position!);
  }
}
