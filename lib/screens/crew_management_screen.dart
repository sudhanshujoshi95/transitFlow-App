import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transit_flow/data/models/crew_list_model.dart';
import 'package:transit_flow/data/models/schedule_bus_model.dart';
import 'package:transit_flow/data/services/bus_services.dart';
import 'package:transit_flow/data/services/crew_services.dart';
import 'package:transit_flow/data/services/scheduled_bus_services.dart';
import 'package:transit_flow/widgets/assign_crew_dialog.dart';
import 'package:transit_flow/widgets/crew_list.dart';
import 'package:transit_flow/widgets/custom_navbar.dart';

class CrewManagementScreen extends StatefulWidget {
  const CrewManagementScreen({Key? key}) : super(key: key);

  @override
  _CrewManagementScreenState createState() => _CrewManagementScreenState();
}

class _CrewManagementScreenState extends State<CrewManagementScreen> {
  // final ScheduledBus bus;  // Pass the scheduled bus here
  late List<CrewMember> crewList = []; // Pass crew list here

  List<ScheduledBus> busesWithoutCrew = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBusesWithoutCrew();
    _fetchCrewList(); // Fetch crew data
  }

  Future<void> _fetchBusesWithoutCrew() async {
    final fetchedBuses =
        await ScheduledBusService().fetchBusesWithoutCrewAssigned();
    setState(() {
      busesWithoutCrew = fetchedBuses;
      isLoading = false; // Update loading status
    });
  }

  Future<void> _fetchCrewList() async {
    final crewService = CrewServices(); // Create an instance of CrewServices
    final fetchedCrew =
        await crewService.fetchCrewMembers(); // Call the instance method
    setState(() {
      crewList = fetchedCrew;
    });
  }

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
                          isLoading // Check if data is still loading
                              ? Center(child: CircularProgressIndicator())
                              : busesWithoutCrew.isEmpty
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 50.0),
                                        child: Text(
                                          'No bus is Found without crew Assignment',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : LayoutBuilder(
                                      builder: (context, constraints) {
                                        final cardWidth =
                                            350.0; // Width of each card
                                        final cardHeight =
                                            210.0; // Height of each card
                                        final crossAxisCount =
                                            (constraints.maxWidth / cardWidth)
                                                .floor();
                                        final itemCount = busesWithoutCrew
                                            .length; // Replace with actual data count
                                        final gridHeight = (itemCount /
                                                    crossAxisCount)
                                                .ceil() *
                                            (cardHeight +
                                                15.0); // Total height for GridView

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
                                              final bus =
                                                  busesWithoutCrew[index];
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
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              bus.busNumber,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AssignCrewDialog(
                                                                bus: bus,
                                                                crewList:
                                                                    crewList,
                                                                onSave: (bool
                                                                        success,
                                                                    List<CrewMember>
                                                                        assignedCrew) async {
                                                                  if (success) {
                                                                    // Check if crew assignment was successful
                                                                    try {
                                                                      bus.isCrewAssigned =
                                                                          true; // Update assignment status
                                                                      bus.crewMembers =
                                                                          assignedCrew; // Update crew members

                                                                      // Call the service to assign crew to the bus
                                                                      await ScheduledBusService()
                                                                          .assignCrewToScheduledBusesWithoutCrew(
                                                                              bus);
                                                                      print(
                                                                          'Crew assigned to bus ${bus.busNumber}');
                                                                    } catch (e) {
                                                                      print(
                                                                          "Error assigning crew: $e");
                                                                      // Optionally show an error dialog to the user
                                                                    }
                                                                  }
                                                                },
                                                              );
                                                            },
                                                          );
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  27,
                                                                  129,
                                                                  212), // Background color
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          minimumSize: const Size(
                                                              120,
                                                              40), // Button size
                                                        ),
                                                        child: const Text(
                                                          'Assign',
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
                                        return GestureDetector(
                                          onTap: () async {
                                            final crewMembers =
                                                await ScheduledBusService()
                                                    .fetchBusesWithCrewAssigned(); // Fetch crew members
                                            _showBusDetailsDialog(context, bus);
                                          },
                                          child: Card(
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Bus ${bus.busNumber}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
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
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Colors
                                                          .green, // Background color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      minimumSize: const Size(
                                                          120,
                                                          40), // Button size
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
            // Crew List Section (Updated to use CrewList)
            CrewList(),
          ],
        ),
      ),
    );
  }

  void _showBusDetailsDialog(BuildContext context, ScheduledBus bus) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Bus ${bus.busNumber} Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Departure: ${bus.departureTime}'),
              Text('Arrival: ${bus.arrivalTime}'),
              Text('From: ${bus.departureLocation}'),
              Text('To: ${bus.arrivalLocation}'),
              const SizedBox(height: 16),
              const Text('Assigned Crew:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (bus.crewMembers != null && bus.crewMembers!.isNotEmpty)
                ...bus.crewMembers!
                    .map((crew) => Text('${crew.name} - ${crew.status}'))
                    .toList()
              else
                const Text('No crew members assigned.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
