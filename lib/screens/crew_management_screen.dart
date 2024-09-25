import 'package:flutter/material.dart';
import 'package:transit_flow/data/models/schedule_bus_model.dart';
import 'package:transit_flow/data/services/scheduled_bus_services.dart';
import 'package:transit_flow/widgets/custom_navbar.dart';

class CrewManagementScreen extends StatelessWidget {
  const CrewManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scheduled Buses without Crew Section
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Scheduled Buses without Crew',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final cardWidth = 350.0; // Width of each card
                              final cardHeight = 210.0; // Height of each card
                              final crossAxisCount =
                                  (constraints.maxWidth / cardWidth).floor();
                              final itemCount =
                                  4; // Replace with actual data count
                              final gridHeight =
                                  (itemCount / crossAxisCount).ceil() *
                                      (cardHeight +
                                          15.0); // Total height for GridView

                              return Container(
                                height: gridHeight,
                                child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: cardWidth / cardHeight,
                                    mainAxisSpacing: 15.0,
                                    crossAxisSpacing: 15.0,
                                  ),
                                  itemCount: itemCount,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Bus $index',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                      'Departure: 08:00 AM'),
                                                  const Text(
                                                      'Arrival: 12:00 PM'),
                                                  const Text(
                                                      'From: Location A'),
                                                  const Text('To: Location B'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Handle button press
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color
                                                    .fromARGB(255, 27, 129,
                                                    212), // Background color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                minimumSize: const Size(
                                                    120, 40), // Button size
                                              ),
                                              child: const Text(
                                                'Assign',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Current Assignments Section
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Assignments',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          FutureBuilder<List<ScheduledBus>>(
                            future: ScheduledBusService()
                                .fetchBusesWithCrewAssigned(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              final buses = snapshot.data;

                              if (buses == null || buses.isEmpty) {
                                return const Center(
                                    child:
                                        Text('No buses with assigned crew.'));
                              }

                              // Calculate grid layout based on the available width
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  final cardWidth = 350.0; // Width of each card
                                  final cardHeight =
                                      210.0; // Height of each card
                                  final crossAxisCount =
                                      (constraints.maxWidth / cardWidth)
                                          .floor();
                                  final itemCount = buses
                                      .length; // Use the actual number of buses
                                  final gridHeight = (itemCount /
                                              crossAxisCount)
                                          .ceil() *
                                      (cardHeight +
                                          20.0); // Calculate total height for GridView

                                  return Container(
                                    height: gridHeight,
                                    child: GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio:
                                            cardWidth / cardHeight,
                                        mainAxisSpacing: 15.0,
                                        crossAxisSpacing: 15.0,
                                      ),
                                      itemCount: itemCount,
                                      itemBuilder: (context, index) {
                                        final bus = buses[index];
                                        return Card(
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Bus ${bus.busNumber}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                          'Departure: ${bus.departureTime}'),
                                                      Text(
                                                          'Arrival: ${bus.arrivalTime}'),
                                                      Text(
                                                          'From: ${bus.departureLocation}'),
                                                      Text(
                                                          'To: ${bus.arrivalLocation}'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // Handle button press (e.g., Edit bus schedule)
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .green, // Background color
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    minimumSize: const Size(
                                                        120, 40), // Button size
                                                  ),
                                                  child: const Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Crew List Section
            Container(
              width: 300, // Fixed width for crew list section
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crew List',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: [
                        CrewMemberTile(name: 'Alice', status: 'Available'),
                        CrewMemberTile(name: 'Bob', status: 'Occupied'),
                        CrewMemberTile(name: 'Charlie', status: 'On Leave'),
                        CrewMemberTile(name: 'David', status: 'Available'),
                        // Add more crew members here
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CrewMemberTile extends StatelessWidget {
  final String name;
  final String status;

  CrewMemberTile({super.key, required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Available':
        statusColor = Colors.green;
        break;
      case 'Occupied':
        statusColor = Colors.orange;
        break;
      case 'On Leave':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(status),
      trailing: CircleAvatar(
        backgroundColor: statusColor,
        radius: 6,
      ),
    );
  }
}
