import 'package:flutter/material.dart';

class Vehicle {
  final String id;
  final String name;
  final IconData icon;

  final double height; // m
  final double width;  // m
  final double length; // m
  final double weight; // kg

  const Vehicle({
    required this.id,
    required this.name,
    required this.icon,
    this.height = 0,
    this.width = 0,
    this.length = 0,
    this.weight = 0,
  });

  Vehicle copyWith({
    String? id,
    String? name,
    IconData? icon,
    double? height,
    double? width,
    double? length,
    double? weight,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      height: height ?? this.height,
      width: width ?? this.width,
      length: length ?? this.length,
      weight: weight ?? this.weight,
    );
  }
}
