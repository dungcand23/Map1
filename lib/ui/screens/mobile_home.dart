import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_notifier.dart';
import '../widgets/stop_list.dart';
import '../widgets/vehicle_selector.dart';
import '../widgets/route_options.dart';
import '../widgets/saved_routes.dart';
import '../../widgets/map_google.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppNotifier>();

    return Scaffold(
      body: Stack(
        children: [
          // MAP GOOGLE
          MapGoogle(selectedRoute: app.state.selectedRoute),

          // BOTTOM SHEET
          DraggableScrollableSheet(
            minChildSize: 0.18,
            maxChildSize: 0.9,
            initialChildSize: 0.24,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 32,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        const StopList(),
                        const SizedBox(height: 12),
                        const Divider(),

                        const SizedBox(height: 12),
                        const VehicleSelector(),
                        const SizedBox(height: 12),
                        const Divider(),

                        const SizedBox(height: 12),
                        RouteOptions(
                          routes: app.state.routeOptions,
                          selectedRoute: app.state.selectedRoute,
                          onSelect: app.selectRoute,
                        ),

                        const SizedBox(height: 12),
                        const Divider(),

                        const SizedBox(height: 12),
                        const SavedRoutes(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
