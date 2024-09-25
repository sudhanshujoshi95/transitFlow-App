import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduledBus {
  final String busNumber;
  final String departureTime;
  final String arrivalTime;
  final String departureLocation;
  final String arrivalLocation;
  final bool isCrewAssigned;
  final List<CrewMember>? crewMembers;

  ScheduledBus({
    required this.busNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.isCrewAssigned,
    this.crewMembers,
  });

  // Create a ScheduledBus instance from a Firestore document
  factory ScheduledBus.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ScheduledBus(
      busNumber: data['busNumber'] ?? '',
      departureTime: data['departureTime'] ?? '',
      arrivalTime: data['arrivalTime'] ?? '',
      departureLocation: data['departureLocation'] ?? '',
      arrivalLocation: data['arrivalLocation'] ?? '',
      isCrewAssigned: data['isCrewAssigned'] ?? false,
      crewMembers: data['crewMembers'] != null
          ? (data['crewMembers'] as List)
              .map((member) => CrewMember.fromMap(member))
              .toList()
          : [],
    );
  }

  // Convert the ScheduledBus object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'busNumber': busNumber,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'departureLocation': departureLocation,
      'arrivalLocation': arrivalLocation,
      'isCrewAssigned': isCrewAssigned,
      'crewMembers': crewMembers!.map((member) => member.toMap()).toList(),
    };
  }
}

class CrewMember {
  final String crewId;
  final String name;
  final String role;
  final String status;

  CrewMember({
    required this.crewId,
    required this.name,
    required this.role,
    required this.status,
  });

  factory CrewMember.fromMap(Map<String, dynamic> data) {
    return CrewMember(
      crewId: data['crewId'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'crewId': crewId,
      'name': name,
      'role': role,
      'status': status,
    };
  }
}
