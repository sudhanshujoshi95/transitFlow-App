import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bus_list_model.dart';

class BusService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all buses from the busList collection
  Future<List<Bus>> fetchAllBuses() async {
    try {
      final snapshot = await _db.collection('busList').get();
      return snapshot.docs.map((doc) => Bus.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching buses: $e');
      return [];
    }
  }

  // Fetch only bus numbers from the busList collection
  Future<List<String>> fetchAllBusNumbers() async {
    try {
      final snapshot =
          await _db.collection('busList').get(); // Fetch all documents
      // Extract only 'busNumber' field from each document
      return snapshot.docs.map((doc) => doc['busNumber'] as String).toList();
    } catch (e) {
      print('Error fetching bus numbers: $e');
      return [];
    }
  }

  // Fetch all existing bus IDs to determine the next ID
  Future<String> getNextBusId() async {
    try {
      // Fetch all documents in the busList collection
      final snapshot = await _db.collection('busList').get();

      // Extract and parse numeric parts of existing bus IDs
      List<int> busNumbers = snapshot.docs
          .map((doc) => doc['busId'])
          .where((id) => id.startsWith('bus_'))
          .map((id) => int.tryParse(id.split('_')[1]) ?? 0)
          .toList();

      // Determine the next ID suffix
      int nextNumber = (busNumbers.isEmpty
              ? 0
              : busNumbers.reduce((a, b) => a > b ? a : b)) +
          1;

      // Format as 'bus_XXX' with leading zeros
      return 'bus_${nextNumber.toString().padLeft(3, '0')}';
    } catch (e) {
      print('Error generating next bus ID: $e');
      return 'bus_001'; // Default ID if fetching fails
    }
  }

  // Function to add a new bus
  Future<void> addBus(Bus bus) async {
    try {
      await _db.collection('busList').add({
        'busNumber': bus.busNumber,
        'busType': bus.busType,
        'capacity': bus.capacity,
        'isAvailable': bus.isAvailable,
        'assignedRoute':
            bus.assignedRoute ?? 'Unassigned', // Fallback in Firestore
        'busId': bus.busId,
      });
      print('New bus added successfully');
    } catch (e) {
      print('Error adding new bus: $e');
    }
  }

  // Update an existing bus
  Future<void> updateBus(String busId, Bus bus) async {
    try {
      await _db.collection('busList').doc(busId).update({
        'busNumber': bus.busNumber,
        'busType': bus.busType,
        'capacity': bus.capacity,
        'isAvailable': bus.isAvailable,
        'assignedRoute': bus.assignedRoute ?? 'Unassigned',
      });
      print('Bus updated successfully with ID: $busId');
    } catch (e) {
      print('Error updating bus with ID $busId: $e');
    }
  }

  // Delete a bus
  Future<void> deleteBus(String busId) async {
    try {
      await _db.collection('busList').doc(busId).delete();
      print('Bus deleted successfully with ID: $busId');
    } catch (e) {
      print('Error deleting bus with ID $busId: $e');
    }
  }
}
