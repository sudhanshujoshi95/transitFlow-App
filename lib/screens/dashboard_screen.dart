import 'package:flutter/material.dart';
import 'package:transit_flow/data/models/schedule_bus_model.dart';
import 'package:transit_flow/data/services/bus_services.dart';
import 'package:transit_flow/data/services/crew_services.dart';
import 'package:transit_flow/data/services/scheduled_bus_services.dart';
import 'package:transit_flow/widgets/maps.dart';
import '../widgets/custom_navbar.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<int> _totalBusesCount;
  late Future<int> _totalCrewMembersCount;
  late Future<int> _totalScheduledBuses;

  @override
  void initState() {
    super.initState();
    // Fetch the total buses count when the screen initializes
    _totalBusesCount = fetchTotalBusesCount();
    _totalCrewMembersCount = fetchTotalCrewMembersCount();
    _totalScheduledBuses = fetchTotalScheduledBuses();
  }

  // Fetch the total count of buses from the service
  Future<int> fetchTotalBusesCount() async {
    try {
      final busService = BusService();
      final buses = await busService
          .fetchAllBuses(); // Assume this returns a list of all buses
      return buses.length; // Return the total number of buses
    } catch (e) {
      print('Error fetching total buses count: $e');
      return 0; // Return 0 in case of error
    }
  }

  // Fetch the total count of buses from the service
  Future<int> fetchTotalCrewMembersCount() async {
    try {
      final crewService = CrewServices();
      final crews = await crewService.fetchCrewMembers(); // Use instance method
      return crews.length; // Return the total number of crew members
    } catch (e) {
      print('Error fetching total crew members count: $e');
      return 0; // Return 0 in case of error
    }
  }

  Future<int> fetchTotalScheduledBuses() async {
    try {
      final scheduled_bus = ScheduledBusService();
      final scheduledBus = await ScheduledBusService
          .fetchAllScheduledBuses(); // Assume this returns a list of all buses
      return scheduledBus.length; // Return the total number of buses
    } catch (e) {
      print('Error fetching total buses count: $e');
      return 0; // Return 0 in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 238, 240, 243),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Heading
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Summary Cards (Crew Stats, Buses in Transit)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FutureBuilder<int>(
                    future: _totalBusesCount,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildDashboardCard(
                          icon: Icons.bus_alert,
                          label: 'Total Buses',
                          value: 'Loading...',
                          color: Colors.blue,
                        );
                      } else if (snapshot.hasError) {
                        return _buildDashboardCard(
                          icon: Icons.bus_alert,
                          label: 'Total Buses',
                          value: 'Error',
                          color: Colors.blue,
                        );
                      } else {
                        return _buildDashboardCard(
                          icon: Icons.bus_alert,
                          label: 'Total Buses',
                          value: snapshot.data.toString(),
                          color: Colors.blue,
                        );
                      }
                    },
                  ),
                  FutureBuilder<int>(
                    future: _totalCrewMembersCount,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildDashboardCard(
                          icon: Icons.group,
                          label: 'Total Crew Members',
                          value: 'Loading...',
                          color: Colors.green,
                        );
                      } else if (snapshot.hasError) {
                        return _buildDashboardCard(
                          icon: Icons.group,
                          label: 'Total Crew Members',
                          value: 'Error',
                          color: Colors.green,
                        );
                      } else {
                        return _buildDashboardCard(
                          icon: Icons.group,
                          label: 'Total Crew Members',
                          value: snapshot.data.toString(),
                          color: Colors.green,
                        );
                      }
                    },
                  ),
                  FutureBuilder<int>(
                    future: _totalScheduledBuses,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildDashboardCard(
                          icon: Icons.schedule,
                          label: 'Upcoming Shifts',
                          value: 'Loading...',
                          color: Colors.orange,
                        );
                      } else if (snapshot.hasError) {
                        return _buildDashboardCard(
                          icon: Icons.schedule,
                          label: 'Upcoming Shifts',
                          value: 'Error',
                          color: Colors.orange,
                        );
                      } else {
                        return _buildDashboardCard(
                          icon: Icons.group,
                          label: 'Upcoming Shifts',
                          value: snapshot.data.toString(),
                          color: Colors.orange,
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Flexbox: Live Bus Tracking + Recent Activity + Alerts Box
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Live Bus Tracking Section
                  Expanded(
                    flex: 7,
                    child: Container(
                      height: 450,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const GoogleMapsWidget(),
                    ),
                  ),

                  // Alerts Section
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Alerts',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Alerts Box (List)
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red, width: 1),
                            ),
                            child: ListView(
                              padding: const EdgeInsets.all(8),
                              children: [
                                _buildAlertItem('Bus #14: Route delayed'),
                                _buildAlertItem('Shift #10: Late start alert'),
                                _buildAlertItem(
                                    'Bus #20: Maintenance required'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dashboard Card Widget
  Widget _buildDashboardCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    double? width, // Optional width parameter
  }) {
    return SizedBox(
      width: width ?? 350, // Set the desired width
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Alert Item Widget
  Widget _buildAlertItem(String alert) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(alert, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
