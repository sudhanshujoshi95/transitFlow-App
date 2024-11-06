import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transit_flow/data/models/crew_list_model.dart';

class CrewServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch crew members
  Future<List<CrewMember>> fetchCrewMembers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('crewMembers').get();
      return snapshot.docs.map((doc) {
        return CrewMember.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching crew members: $e');
      return [];
    }
  }

  // Add a new crew member
  Future<void> addCrewMember(CrewMember crewMember) async {
    try {
      await _firestore
          .collection('crewMembers')
          .doc(crewMember.crewId) // Using crewId as document ID
          .set(crewMember.toMap());
    } catch (e) {
      print('Error adding crew member: $e');
    }
  }

  // Update an existing crew member
  Future<void> updateCrewMember(
      String crewId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection('crewMembers')
          .doc(crewId)
          .update(updatedData);
    } catch (e) {
      print('Error updating crew member: $e');
    }
  }

  // Delete a crew member
  Future<void> deleteCrewMember(String crewId) async {
    try {
      await _firestore.collection('crewMembers').doc(crewId).delete();
    } catch (e) {
      print('Error deleting crew member: $e');
    }
  }
}
