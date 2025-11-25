import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_notifier.dart';
import '../../models/saved_route.dart';

class SavedRoutes extends StatelessWidget {
  const SavedRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppNotifier>();
    final list = app.state.savedRoutes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tuyến đã lưu",
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),

        if (list.isEmpty)
          const Text("Chưa có tuyến nào."),

        for (final r in list)
          _tile(context, r),
      ],
    );
  }

  Widget _tile(BuildContext context, SavedRoute r) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.map),
          const SizedBox(width: 10),
          Expanded(child: Text(r.name)),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                context.read<AppNotifier>().deleteSavedRoute(r),
          ),
        ],
      ),
    );
  }
}
