import 'package:flutter/material.dart';
import '../data/models/bus_list_model.dart';
import '../data/services/bus_services.dart';
import '../widgets/custom_navbar.dart';

class BusListScreen extends StatelessWidget {
  final BusService _busService = BusService(); // Initialize BusService

  BusListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(),
      body: FutureBuilder<List<Bus>>(
        future: _busService.fetchAllBuses(), // Fetch buses
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show loader while data is being fetched
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text('Error fetching bus data')); // Show error if any
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No buses available')); // Show message if no data
          }

          // Display list of buses as cards
          final buses = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final bus = buses[index];
              return BusCard(bus: bus);
            },
          );
        },
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  final Bus bus;

  const BusCard({super.key, required this.bus});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bus Number: ${bus.busNumber}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bus Type: ${bus.busType}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Capacity: ${bus.capacity}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Availability: ${bus.isAvailable ? 'Available' : 'Not Available'}',
              style: TextStyle(
                fontSize: 16,
                color: bus.isAvailable ? Colors.green : Colors.red,
              ),
            ),
            if (bus.assignedRoute != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Assigned Route: ${bus.assignedRoute}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
