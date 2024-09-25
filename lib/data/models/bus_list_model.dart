// models/bus_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Bus {
  final String busId;
  final String busNumber;
  final String busType;
  final int capacity;
  final bool isAvailable;
  final String? assignedRoute;

  Bus({
    required this.busId,
    required this.busNumber,
    required this.busType,
    required this.capacity,
    required this.isAvailable,
    this.assignedRoute,
  });

  factory Bus.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Bus(
      busId: doc.id,
      busNumber: data['busNumber'] ?? '',
      busType: data['busType'] ?? '',
      capacity: data['capacity'] ?? 0,
      isAvailable: data['isAvailable'] ?? false,
      assignedRoute: data['assignedRoute'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'busNumber': busNumber,
      'busType': busType,
      'capacity': capacity,
      'isAvailable': isAvailable,
      'assignedRoute': assignedRoute,
    };
  }
}
