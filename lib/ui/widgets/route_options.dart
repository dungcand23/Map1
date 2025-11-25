import 'package:flutter/material.dart';

import '../../models/route_option.dart';

class RouteOptions extends StatelessWidget {
  final List<RouteOption> routes;
  final RouteOption? selectedRoute;
  final Function(RouteOption) onSelect;

  const RouteOptions({
    super.key,
    required this.routes,
    required this.selectedRoute,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (routes.isEmpty) {
      return const Text("Chưa có tuyến đường.\nNhấn Route để tính tuyến.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tuyến đường đề xuất",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),

        for (final r in routes)
          _buildTile(context, r),
      ],
    );
  }

  Widget _buildTile(BuildContext ctx, RouteOption r) {
    final selected = r.id == selectedRoute?.id;

    return InkWell(
      onTap: () => onSelect(r),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(r.title, style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text("${r.distanceText} • ${r.durationText}"),
            if (r.fuelCost != null)
              Text(
                "Chi phí nhiên liệu: ${r.fuelCost!.toStringAsFixed(0)} đ",
                style: const TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
