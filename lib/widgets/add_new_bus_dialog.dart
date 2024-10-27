import 'package:flutter/material.dart';
import 'package:transit_flow/data/models/bus_list_model.dart';
import 'package:transit_flow/data/services/bus_services.dart';

class AddBusDialog extends StatefulWidget {
  final VoidCallback onBusAdded; // Callback to refresh bus list

  const AddBusDialog({Key? key, required this.onBusAdded}) : super(key: key);

  @override
  _AddBusDialogState createState() => _AddBusDialogState();
}

class _AddBusDialogState extends State<AddBusDialog> {
  final BusService _busService = BusService();
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _assignedRouteController =
      TextEditingController();

  String? _busType;
  bool _isAvailable = true;
  bool _isLoading = false;

  void _addBus() async {
    // Generate the next bus ID
    String busId = await _busService.getNextBusId();
    setState(() {
      _isLoading = true;
    });

    try {
      // Create a new Bus instance with the entered data
      Bus newBus = Bus(
        busId: busId,
        busNumber: _busNumberController.text,
        busType: _busType ?? '',
        capacity: int.tryParse(_capacityController.text) ?? 0,
        isAvailable: _isAvailable,
        assignedRoute: _assignedRouteController.text.isNotEmpty
            ? _assignedRouteController.text
            : 'Unassigned',
      );

      // Call the addBus function from BusService
      await _busService.addBus(newBus);

      // Notify parent widget to refresh list and close dialog
      widget.onBusAdded();
      Navigator.of(context).pop();
    } catch (e) {
      print('Error adding bus: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add bus')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Bus',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // First Row: Bus Number and Bus Type
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _busNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Bus Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _busType,
                      items: ['AC', 'NON-AC', 'Standard Bus', 'Other']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() {
                        _busType = value;
                      }),
                      decoration: const InputDecoration(
                        labelText: 'Bus Type',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Select a bus type' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Second Row: Capacity and Assigned Route
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Capacity',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _assignedRouteController,
                      decoration: const InputDecoration(
                        labelText: 'Assigned Route',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Availability Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Availability:'),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: _isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                        });
                      },
                      activeTrackColor: const Color.fromARGB(255, 53, 123, 180),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.black12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Add Bus Button
              ElevatedButton(
                onPressed: _isLoading ? null : _addBus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 53, 123, 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Add Bus',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
