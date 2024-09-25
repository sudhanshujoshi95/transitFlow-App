import 'package:flutter/material.dart';
import 'package:transit_flow/data/models/bus_list_model.dart';
import 'package:transit_flow/data/models/schedule_bus_model.dart';
import 'package:transit_flow/data/services/scheduled_bus_services.dart';
import 'package:transit_flow/widgets/custom_navbar.dart';
import 'package:transit_flow/widgets/footer_widget.dart';
import '../data/services/bus_services.dart'; // Import your bus service

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String? selectedBusNumber; // Variable to hold the selected bus number
  TimeOfDay? selectedDepartureTime;
  TimeOfDay? selectedArrivalTime;
  final TextEditingController _departureLocationController =
      TextEditingController();
  final TextEditingController _arrivalLocationController =
      TextEditingController();

  // Utility function to format TimeOfDay to HH:mm format
  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

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

                                  // Fetch and display dropdown of bus numbers
                                  FutureBuilder<List<String>>(
                                    future: BusService().fetchAllBusNumbers(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Error fetching bus numbers');
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return const Text(
                                            'No bus numbers available');
                                      }

                                      final busNumbers = snapshot.data!;

                                      return Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: DropdownButton<String>(
                                            value: selectedBusNumber,
                                            hint:
                                                const Text('Select Bus Number'),
                                            isExpanded: true,
                                            underline: Container(),
                                            items: busNumbers.map((busNumber) {
                                              return DropdownMenuItem<String>(
                                                value: busNumber,
                                                child: Text(busNumber),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedBusNumber = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Departure Time with DatePicker
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Departure Time',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: selectedDepartureTime ??
                                            TimeOfDay.now(),
                                      );
                                      if (pickedTime != null) {
                                        setState(() {
                                          selectedDepartureTime = pickedTime;
                                        });
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: selectedDepartureTime !=
                                                      null
                                                  ? formatTime(
                                                      selectedDepartureTime!)
                                                  : 'Select Departure Time',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Arrival Time with DatePicker
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Arrival Time',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: selectedArrivalTime ??
                                            TimeOfDay.now(),
                                      );
                                      if (pickedTime != null) {
                                        setState(() {
                                          selectedArrivalTime = pickedTime;
                                        });
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  selectedArrivalTime != null
                                                      ? formatTime(
                                                          selectedArrivalTime!)
                                                      : 'Select Arrival Time',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Other inputs (locations) are here...
                        // Departure Location and Arrival Location Inputs
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Departure Location',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: TextField(
                                        controller:
                                            _departureLocationController,
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
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Arrival Location',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: TextField(
                                        controller: _arrivalLocationController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Arrival Location',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Add Schedule Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 35,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              // Handle the add schedule functionality here
                              if (selectedBusNumber == null ||
                                  selectedDepartureTime == null ||
                                  selectedArrivalTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please fill in all the fields properly'),
                                  ),
                                );
                                return;
                              }
                              // Add your schedule logic
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

                          // Horizontal List of Buses without Crew
                          FutureBuilder<List<ScheduledBus>>(
                            future: ScheduledBusService()
                                .fetchBusesWithoutCrewAssigned(),
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
                                    child: Text(
                                        'No buses available without crew'));
                              }

                              return Container(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: buses.length,
                                  itemBuilder: (context, index) {
                                    final bus = buses[index];
                                    return _buildBusCard(
                                      busNumber: bus
                                          .busNumber, // Assuming 'number' is a field in Bus model
                                      departureTime: bus
                                          .departureTime, // Modify according to your model
                                      arrivalTime: bus
                                          .arrivalTime, // Modify according to your model
                                      departureLocation: bus
                                          .departureLocation, // Modify according to your model
                                      arrivalLocation: bus
                                          .arrivalLocation, // Modify according to your model
                                    );
                                  },
                                ),
                              );
                            },
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
