import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_notifier.dart';
import '../../services/search_service.dart';
import '../../services/location_service.dart';
import '../../models/place_suggestion.dart';
import '../../models/stop.dart';
import '../../models/vehicle.dart';

class StopList extends StatefulWidget {
  const StopList({super.key});

  @override
  State<StopList> createState() => _StopListState();
}

class _StopListState extends State<StopList> {
  final _controllers = <TextEditingController>[];
  final _focusNodes = <FocusNode>[];

  List<PlaceSuggestion> _suggestions = [];
  int _activeIndex = -1;

  @override
  void initState() {
    super.initState();
    final app = context.read<AppNotifier>();
    for (final s in app.state.stops) {
      _controllers.add(TextEditingController(text: s.label));
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  Future<void> _onQuery(String q, int index) async {
    if (q.trim().isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    _activeIndex = index;
    final list = await SearchService().autocomplete(q);
    setState(() => _suggestions = list);
  }

  Future<void> _useCurrentLocation(int index) async {
    final loc = await LocationService().getCurrentLocation();
    if (loc == null) return;

    final app = context.read<AppNotifier>();
    final label = index == 0 ? "Vị trí của bạn" : "Vị trí hiện tại";

    _controllers[index].text = label;
    app.updateStop(index, label: label, location: loc);

    setState(() => _suggestions = []);
  }

  Future<void> _chooseSuggestion(
      PlaceSuggestion s, int index) async {
    final loc = await SearchService().getPlaceLocation(s.placeId);
    if (loc == null) return;

    final app = context.read<AppNotifier>();

    _controllers[index].text = s.description;
    app.updateStop(index, label: s.description, location: loc);

    setState(() => _suggestions = []);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppNotifier>();
    final stops = app.state.stops;
    final vehicles = app.state.vehicles;
    final defaultVehicle = app.state.currentVehicle;

    // đảm bảo số controller khớp số stop
    while (_controllers.length < stops.length) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Điểm đi / đến",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),

        for (int i = 0; i < stops.length; i++)
          _buildField(
            context,
            index: i,
            stop: stops[i],
            vehicles: vehicles,
            defaultVehicle: defaultVehicle,
          ),

        if (_suggestions.isNotEmpty && _activeIndex != -1)
          _buildSuggestionPanel(_activeIndex),
      ],
    );
  }

  Widget _buildField(
      BuildContext context, {
        required int index,
        required Stop stop,
        required List<Vehicle> vehicles,
        required Vehicle defaultVehicle,
      }) {
    final app = context.read<AppNotifier>();
    final vehicle = stop.vehicle ?? defaultVehicle;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        decoration: InputDecoration(
          hintText: index == 0 ? "Vị trí của bạn" : "Chọn điểm đến",
          prefixIcon: Icon(
            index == 0 ? Icons.my_location : Icons.place,
            size: 20,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: "Chọn xe cho điểm này",
                icon: Icon(vehicle.icon, size: 20),
                onPressed: () async {
                  final chosen = await showModalBottomSheet<Vehicle>(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (ctx) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Chọn phương tiện cho điểm này",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              for (final v in vehicles)
                                ListTile(
                                  leading: Icon(v.icon),
                                  title: Text(v.name),
                                  onTap: () => Navigator.of(ctx).pop(v),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  if (chosen != null) {
                    app.setStopVehicle(index, chosen);
                    setState(() {});
                  }
                },
              ),
            ],
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (q) => _onQuery(q, index),
        onTap: () => setState(() => _activeIndex = index),
      ),
    );
  }

  Widget _buildSuggestionPanel(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // dòng "Vị trí hiện tại của tôi"
          ListTile(
            leading: const Icon(Icons.my_location),
            title: const Text("Sử dụng vị trí hiện tại của tôi"),
            onTap: () => _useCurrentLocation(index),
          ),
          if (_suggestions.isNotEmpty)
            const Divider(height: 1),

          for (final s in _suggestions)
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(s.description),
              onTap: () => _chooseSuggestion(s, index),
            ),
        ],
      ),
    );
  }
}
