import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transit_flow/data/models/schedule_bus_model.dart';

class ScheduledBusService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
}
