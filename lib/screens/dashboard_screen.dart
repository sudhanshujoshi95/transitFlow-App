import 'package:flutter/material.dart';
import 'package:transit_flow/widgets/maps.dart';
import '../widgets/custom_navbar.dart';

class DashboardScreen extends StatelessWidget {
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
                  _buildDashboardCard(
                    icon: Icons.bus_alert,
                    label: 'Active Buses',
                    value: '15',
                    color: Colors.blue,
                  ),
                  _buildDashboardCard(
                    icon: Icons.group,
                    label: 'Crew Members',
                    value: '120',
                    color: Colors.green,
                  ),
                  _buildDashboardCard(
                    icon: Icons.schedule,
                    label: 'Upcoming Shifts',
                    value: '8',
                    color: Colors.orange,
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
