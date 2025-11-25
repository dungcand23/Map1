import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_notifier.dart';
import '../../models/vehicle.dart';

class VehicleSelector extends StatelessWidget {
  const VehicleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppNotifier>();
    final vehicles = app.state.vehicles;
    final current = app.state.currentVehicle;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phương tiện mặc định",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // HÀNG: chips xe (trái) + nút Route tròn (phải)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CHỌN XE + XE MỚI
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final v in vehicles)
                    ChoiceChip(
                      avatar: Icon(v.icon, size: 18),
                      label: Text(v.name),
                      selected: v.id == current.id,
                      onSelected: (_) => app.selectVehicle(v),
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 18),
                    label: const Text("Xe mới"),
                    onPressed: () async {
                      final newVehicle = await showDialog<Vehicle>(
                        context: context,
                        builder: (_) => const _NewVehicleDialog(),
                      );
                      if (newVehicle != null) {
                        app.addVehicle(newVehicle);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // NÚT ROUTE TRÒN
            Column(
              children: [
                InkWell(
                  onTap: () => app.generateRoutes(),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                          theme.colorScheme.primary.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.alt_route_rounded,
                      color: theme.colorScheme.onPrimary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Route",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 6),
        Text(
          "Xe hiện tại: ${current.name} • Cao ${current.height} m • Rộng ${current.width} m • Dài ${current.length} m • ${current.weight.toStringAsFixed(0)} kg",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Dialog thêm xe mới
class _NewVehicleDialog extends StatefulWidget {
  const _NewVehicleDialog();

  @override
  State<_NewVehicleDialog> createState() => _NewVehicleDialogState();
}

class _NewVehicleDialogState extends State<_NewVehicleDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _lengthCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  static const _iconOptions = <IconData>[
    Icons.directions_car,
    Icons.two_wheeler,
    Icons.local_shipping,
    Icons.fire_truck,
    Icons.airport_shuttle,
  ];

  IconData _selectedIcon = _iconOptions.first;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _heightCtrl.dispose();
    _widthCtrl.dispose();
    _lengthCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Thêm phương tiện mới"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_selectedIcon, size: 48, color: theme.colorScheme.primary),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final icon in _iconOptions)
                    GestureDetector(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: icon == _selectedIcon
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceVariant,
                          border: Border.all(
                            color: icon == _selectedIcon
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(icon, size: 22),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              _field(
                label: "Tên xe",
                controller: _nameCtrl,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? "Nhập tên xe" : null,
              ),
              _field(
                label: "Cao (m)",
                controller: _heightCtrl,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
              ),
              _field(
                label: "Rộng (m)",
                controller: _widthCtrl,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
              ),
              _field(
                label: "Dài (m)",
                controller: _lengthCtrl,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
              ),
              _field(
                label: "Tải trọng (kg)",
                controller: _weightCtrl,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Hủy"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          child: const Text("Lưu"),
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;

            final v = Vehicle(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameCtrl.text.trim(),
              icon: _selectedIcon,
              height: double.tryParse(
                  _heightCtrl.text.replaceAll(',', '.')) ??
                  0,
              width: double.tryParse(
                  _widthCtrl.text.replaceAll(',', '.')) ??
                  0,
              length: double.tryParse(
                  _lengthCtrl.text.replaceAll(',', '.')) ??
                  0,
              weight: double.tryParse(
                  _weightCtrl.text.replaceAll(',', '.')) ??
                  0,
            );

            Navigator.of(context).pop(v);
          },
        ),
      ],
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          isDense: true,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
