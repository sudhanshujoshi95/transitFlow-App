import 'package:flutter/material.dart';
import 'package:transit_flow/widgets/add_new_bus_dialog.dart';
import '../data/models/bus_list_model.dart';
import '../data/services/bus_services.dart';
import '../widgets/custom_navbar.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({Key? key}) : super(key: key);

  @override
  _BusListScreenState createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  final BusService _busService = BusService(); // Initialize BusService
  List<Bus> _busList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBusList();
  }

  // Fetch bus list and refresh UI
  void _fetchBusList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final buses = await _busService.fetchAllBuses();
      setState(() {
        _busList = buses;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching bus data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddBusDialog() {
    showDialog(
      context: context,
      builder: (context) => AddBusDialog(
        onBusAdded: _fetchBusList, // Pass function to refresh bus list
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _showAddBusDialog,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add New Bus',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 53, 123, 180), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _busList.isEmpty
                    ? const Center(child: Text('No buses available'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: _busList.length,
                        itemBuilder: (context, index) {
                          final bus = _busList[index];
                          return BusCard(
                              bus: bus,
                              onUpdate: _fetchBusList, // Pass refresh callback
                              onDelete:
                                  _fetchBusList); // Pass refresh callback);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class BusCard extends StatefulWidget {
  final Bus bus;
  final Function() onUpdate; // Callback for updating the bus list
  final Function() onDelete; // Callback for deleting the bus

  BusCard({required this.bus, required this.onUpdate, required this.onDelete});

  @override
  _BusCardState createState() => _BusCardState();
}

class _BusCardState extends State<BusCard> {
  final BusService busService = BusService();
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  late TextEditingController busNumberController;
  late TextEditingController busTypeController;
  late TextEditingController capacityController;

  @override
  void initState() {
    super.initState();
    busNumberController = TextEditingController(text: widget.bus.busNumber);
    busTypeController = TextEditingController(text: widget.bus.busType);
    capacityController =
        TextEditingController(text: widget.bus.capacity.toString());
  }

  @override
  void dispose() {
    busNumberController.dispose();
    busTypeController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  // Function to show the update bus dialog
  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Bus Info'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: busNumberController,
                  decoration: InputDecoration(labelText: 'Bus Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter bus number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: busTypeController,
                  decoration: InputDecoration(labelText: 'Bus Type'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter bus type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: capacityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Capacity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter capacity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Create updated Bus object
                  Bus updatedBus = Bus(
                    busId: widget.bus.busId,
                    busNumber: busNumberController.text,
                    busType: busTypeController.text,
                    capacity: int.parse(capacityController.text),
                    isAvailable: widget.bus.isAvailable,
                    assignedRoute: widget.bus.assignedRoute,
                  );

                  // Update the bus using the busId
                  busService.updateBus(widget.bus.busId, updatedBus).then((_) {
                    Navigator.of(context).pop(); // Close the dialog
                    widget
                        .onUpdate(); // Call the callback to refresh the bus list
                  });
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete the bus
  void _deleteBus(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Bus'),
          content: Text('Are you sure you want to delete this bus?'),
          actions: [
            TextButton(
              onPressed: () {
                busService.deleteBus(widget.bus.busId).then((_) {
                  Navigator.of(context).pop(); // Close the dialog
                  widget
                      .onDelete(); // Call the callback to refresh the bus list
                });
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Adjusted padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Positioning the buttons at the top right
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showUpdateDialog(context),
                    color: const Color.fromARGB(255, 53, 123, 180),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteBus(context),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            // Bus information
            ListTile(
              title: Text('Bus Number: ${widget.bus.busNumber}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: Text('Bus Type: ${widget.bus.busType}',
                  style: TextStyle(fontSize: 16)),
            ),
            ListTile(
              title: Text('Capacity: ${widget.bus.capacity}',
                  style: TextStyle(fontSize: 16)),
            ),
            ListTile(
              title: Text('Available: ${widget.bus.isAvailable ? "Yes" : "No"}',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
