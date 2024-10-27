import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transit_flow/data/models/crew_list_model.dart';

class ScheduledBus {
  final String? docId;
  final String busNumber;
  final String departureTime;
  final String arrivalTime;
  final String departureLocation;
  final String arrivalLocation;
  final bool isCrewAssigned;
  final List<CrewMember>? crewMembers;

  ScheduledBus({
    this.docId,
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
      docId: doc.id,
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
