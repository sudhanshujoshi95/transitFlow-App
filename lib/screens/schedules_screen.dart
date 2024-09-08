import 'package:flutter/material.dart';
import 'package:transit_flow/widgets/custom_navbar.dart';
import 'package:transit_flow/widgets/footer_widget.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 238, 240, 243),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Section 1: Add Bus Schedule
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Bus Schedule',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Bus Number and Departure Time Input
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Bus Number',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Bus Number',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Departure Time',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Departure Time',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Arrival Time and Departure Location Input
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Arrival Time',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Arrival Time',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Departure Location',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Departure Location',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Arrival Location Input
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Arrival Location',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Arrival Location',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Add Schedule Button
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 35,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              // Handle the add schedule functionality here
                            },
                            label: const Text('Add Schedule',
                                style: TextStyle(color: Colors.white)),
                            icon: const Icon(Icons.add, color: Colors.white),
                            backgroundColor:
                                const Color.fromARGB(255, 53, 123, 180),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Section 2: Upcoming Bus Journeys
                SizedBox(
                  height: 320,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    margin: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upcoming Bus Journeys',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Horizontal List of Bus Cards
                          Container(
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildBusCard(
                                  busNumber: 'Bus #101',
                                  departureTime: '10:00 AM',
                                  arrivalTime: '12:00 PM',
                                  departureLocation: 'Station A',
                                  arrivalLocation: 'Station B',
                                ),
                                const SizedBox(width: 16),
                                _buildBusCard(
                                  busNumber: 'Bus #102',
                                  departureTime: '11:00 AM',
                                  arrivalTime: '01:00 PM',
                                  departureLocation: 'Station C',
                                  arrivalLocation: 'Station D',
                                ),
                                const SizedBox(width: 16),
                                _buildBusCard(
                                  busNumber: 'Bus #107',
                                  departureTime: '10:00 AM',
                                  arrivalTime: '12:00 PM',
                                  departureLocation: 'Station A',
                                  arrivalLocation: 'Station B',
                                ),
                                const SizedBox(width: 16),
                                _buildBusCard(
                                  busNumber: 'Bus #108',
                                  departureTime: '10:00 AM',
                                  arrivalTime: '12:00 PM',
                                  departureLocation: 'Station A',
                                  arrivalLocation: 'Station B',
                                ),
                                const SizedBox(width: 16),
                                _buildBusCard(
                                  busNumber: 'Bus #110',
                                  departureTime: '10:00 AM',
                                  arrivalTime: '12:00 PM',
                                  departureLocation: 'Station A',
                                  arrivalLocation: 'Station B',
                                ),
                                // Add more bus cards as needed
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Bus Card Widget
  Widget _buildBusCard({
    required String busNumber,
    required String departureTime,
    required String arrivalTime,
    required String departureLocation,
    required String arrivalLocation,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                busNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Departure Time: $departureTime'),
              const SizedBox(height: 4),
              Text('Arrival Time: $arrivalTime'),
              const SizedBox(height: 4),
              Text('Departure Location: $departureLocation'),
              const SizedBox(height: 4),
              Text('Arrival Location: $arrivalLocation'),
            ],
          ),
        ),
      ),
    );
  }
}
