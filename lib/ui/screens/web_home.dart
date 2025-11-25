import 'package:flutter/material.dart';
import '../../widgets/map_stub.dart';
import '../widgets/stop_list.dart';
import '../widgets/vehicle_selector.dart';
import '../widgets/route_options.dart';
import '../widgets/saved_routes.dart';
import 'package:provider/provider.dart';
import '../../state/app_notifier.dart';

class WebHome extends StatelessWidget {
  const WebHome({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppNotifier>();

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 380,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StopList(),
                  const SizedBox(height: 16),
                  const VehicleSelector(),
                  const SizedBox(height: 16),
                  RouteOptions(
                    routes: app.state.routeOptions,
                    selectedRoute: app.state.selectedRoute,
                    onSelect: app.selectRoute,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => app.generateRoutes(),
                    icon: const Icon(Icons.alt_route),
                    label: const Text("Route"),
                  ),
                  const Divider(),
                  const SavedRoutes(),
                ],
              ),
            ),
          ),
          Expanded(child: MapStub()),
        ],
      ),
    );
  }
}
