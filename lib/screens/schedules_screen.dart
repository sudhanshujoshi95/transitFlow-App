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

  void _addBusSchedule() async {
    if (selectedBusNumber != null &&
        selectedDepartureTime != null &&
        selectedArrivalTime != null &&
        _departureLocationController.text.isNotEmpty &&
        _arrivalLocationController.text.isNotEmpty) {
      // Format the times using the formatTime function
      final departureTimeFormatted = formatTime(selectedDepartureTime!);
      final arrivalTimeFormatted = formatTime(selectedArrivalTime!);

      final scheduleBus = ScheduledBus(
        busNumber: selectedBusNumber!,
        departureTime: departureTimeFormatted,
        arrivalTime: arrivalTimeFormatted,
        departureLocation: _departureLocationController.text,
        arrivalLocation: _arrivalLocationController.text,
        isCrewAssigned: false,
        crewMembers: [],
      );

      try {
        // Check if there is a time overlap before adding the bus schedule
        final hasOverlap =
            await ScheduledBusService().checkTimeOverlap(scheduleBus);
        if (hasOverlap) {
          // Show a warning SnackBar if there is a time overlap
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Time overlap detected! Bus is already scheduled for this period of time. '),
              backgroundColor: Color.fromARGB(255, 216, 81, 71),
            ),
          );
          return; // Exit the function early
        }

        // Add the bus schedule if no overlap
        await ScheduledBusService().addScheduledBus(scheduleBus, context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bus schedule added successfully!')),
        );
        _clearInputs();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add bus schedule!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields!')),
      );
    }
  }

  void _clearInputs() {
    _departureLocationController.clear();
    _arrivalLocationController.clear();
    setState(() {
      selectedBusNumber = null;
      selectedDepartureTime = null;
      selectedArrivalTime = null;
    });
  }

  late Future<List<ScheduledBus>> _busesWithoutCrewFuture;

  @override
  void initState() {
    super.initState();
    // Initial fetching of buses without crew
    _fetchBusesWithoutCrew();
  }

  void _fetchBusesWithoutCrew() {
    _busesWithoutCrewFuture =
        ScheduledBusService().fetchBusesWithoutCrewAssigned();
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

                              _addBusSchedule(); // Add your schedule logic
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
                            future: _busesWithoutCrewFuture,
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
                                      context, // Pass the context to handle delete action
                                      bus: bus,
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
  // Function to build each bus card
  Widget _buildBusCard(BuildContext context, {required ScheduledBus bus}) {
    return SizedBox(
      width: 350,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(right: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bus.busNumber, // Display bus number
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Departure: ${bus.departureTime}'),
                  Text('Arrival: ${bus.arrivalTime}'),
                  Text('From: ${bus.departureLocation}'),
                  Text('To: ${bus.arrivalLocation}'),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  // Show a confirmation dialog before deletion
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete this bus?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  // If confirmed, delete the bus and refresh the list
                  if (confirm == true) {
                    await ScheduledBusService().deleteScheduledBus(bus.docId!);
                    setState(() {
                      // Re-fetch the list or remove the item from the list
                      _fetchBusesWithoutCrew();
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
