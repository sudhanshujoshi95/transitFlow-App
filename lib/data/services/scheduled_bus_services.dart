import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transit_flow/data/models/schedule_bus_model.dart';

class ScheduledBusService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all scheduled buses (with and without crew assigned)
  static Future<List<ScheduledBus>> fetchAllScheduledBuses() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('scheduled_buses').get();
      return snapshot.docs
          .map((doc) => ScheduledBus.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching all scheduled buses: $e');
      return [];
    }
  }

  // Fetch bus schedules with crew assigned
  Future<List<ScheduledBus>> fetchBusesWithCrewAssigned() async {
    try {
      final snapshot = await _db
          .collection('scheduled_buses')
          .where('isCrewAssigned', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => ScheduledBus.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching buses with crew assigned: $e');
      return [];
    }
  }

  // Fetch bus schedules without crew assigned
  Future<List<ScheduledBus>> fetchBusesWithoutCrewAssigned() async {
    try {
      final snapshot = await _db
          .collection('scheduled_buses')
          .where('isCrewAssigned', isEqualTo: false)
          .get();

      return snapshot.docs
          .map((doc) => ScheduledBus.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching buses without crew assigned: $e');
      return [];
    }
  }

  // Update bus schedules
  Future<void> updateScheduledBus(ScheduledBus scheduledBus) async {
    try {
      await _db
          .collection('scheduledBuses')
          .doc(scheduledBus.busNumber)
          .update({
        'departureTime': scheduledBus.departureTime,
        'arrivalTime': scheduledBus.arrivalTime,
        'departureLocation': scheduledBus.departureLocation,
        'arrivalLocation': scheduledBus.arrivalLocation,
        'isCrewAssigned': scheduledBus.isCrewAssigned,
        'crewMembers':
            scheduledBus.crewMembers!.map((member) => member.toMap()).toList(),
      });
      print('Scheduled bus updated successfully');
    } catch (e) {
      print('Error updating scheduled bus: $e');
    }
  }

  // Add a new bus schedule
  Future<void> addScheduledBus(ScheduledBus scheduledBus) async {
    try {
      await _db.collection('scheduled_buses').add({
        'busNumber': scheduledBus.busNumber,
        'departureTime': scheduledBus.departureTime,
        'arrivalTime': scheduledBus.arrivalTime,
        'departureLocation': scheduledBus.departureLocation,
        'arrivalLocation': scheduledBus.arrivalLocation,
        'isCrewAssigned': scheduledBus.isCrewAssigned,
        'crewMembers': scheduledBus.crewMembers
                ?.map((member) => member.toMap())
                .toList() ??
            [],
      });
      print('Scheduled bus added successfully');
    } catch (e) {
      print('Error adding scheduled bus: $e');
    }
  }
}
