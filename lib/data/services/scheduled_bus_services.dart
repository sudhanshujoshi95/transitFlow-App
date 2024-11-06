import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transit_flow/data/models/schedule_bus_model.dart';

class ScheduledBusService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch schedules for a specific bus by bus number
  Future<List<ScheduledBus>> getSchedulesForBus(String busNumber) async {
    try {
      final snapshot = await _db
          .collection('scheduled_buses')
          .where('busNumber', isEqualTo: busNumber)
          .get();

      return snapshot.docs
          .map((doc) => ScheduledBus.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching schedules for bus $busNumber: $e');
      return [];
    }
  }

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

  Future<void> assignCrewToScheduledBusesWithoutCrew(ScheduledBus bus) async {
    try {
      await _db.collection('scheduled_buses').doc(bus.docId).update({
        'isCrewAssigned': bus.isCrewAssigned,
        'crewMembers':
            bus.crewMembers?.map((member) => member.toMap()).toList(),
      });
    } catch (e) {
      print('Error updating scheduled bus: $e');
    }
  }

  // Check if the new schedule overlaps with any existing schedule for that bus
  Future<bool> checkTimeOverlap(ScheduledBus scheduledBus) async {
    final snapshot = await _db
        .collection('scheduled_buses')
        .where('busNumber', isEqualTo: scheduledBus.busNumber)
        .get();

    for (var doc in snapshot.docs) {
      final existingBus = ScheduledBus.fromDocument(doc);

      // Use String-based time comparison
      if (isTimeOverlap(scheduledBus.departureTime, scheduledBus.arrivalTime,
          existingBus.departureTime, existingBus.arrivalTime)) {
        return true;
      }
    }
    return false;
  }

  bool isTimeOverlap(String newStart, String newEnd, String existingStart,
      String existingEnd) {
    // Convert time strings into DateTime objects with today's date for comparison
    final today = DateTime.now();

    final newStartTime = DateTime(today.year, today.month, today.day,
        int.parse(newStart.split(':')[0]), int.parse(newStart.split(':')[1]));

    final newEndTime = DateTime(today.year, today.month, today.day,
        int.parse(newEnd.split(':')[0]), int.parse(newEnd.split(':')[1]));

    final existingStartTime = DateTime(
        today.year,
        today.month,
        today.day,
        int.parse(existingStart.split(':')[0]),
        int.parse(existingStart.split(':')[1]));

    final existingEndTime = DateTime(
        today.year,
        today.month,
        today.day,
        int.parse(existingEnd.split(':')[0]),
        int.parse(existingEnd.split(':')[1]));

    // Check if the new schedule overlaps with the existing schedule
    return newStartTime.isBefore(existingEndTime) &&
        newEndTime.isAfter(existingStartTime);
  }

  // Add a new bus schedule with overlap check
  Future<void> addScheduledBus(ScheduledBus scheduledBus, context) async {
    try {
      final hasOverlap = await checkTimeOverlap(scheduledBus);
      if (hasOverlap) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Bus is already scheduled between ${scheduledBus.departureTime} and ${scheduledBus.arrivalTime}.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

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

  // Delete a scheduled bus by document ID
  Future<void> deleteScheduledBus(String docId) async {
    try {
      await _db.collection('scheduled_buses').doc(docId).delete();
      print('Scheduled bus deleted successfully');
    } catch (e) {
      print('Error deleting scheduled bus: $e');
    }
  }
}
