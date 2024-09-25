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
}
