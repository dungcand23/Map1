import 'package:flutter/material.dart';

class MapStub extends StatelessWidget {
  const MapStub({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Text(
          "Map\n(Web Stub)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, color: Colors.black54),
        ),
      ),
    );
  }
}
