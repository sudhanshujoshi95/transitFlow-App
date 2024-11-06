import 'package:flutter/material.dart';
import 'package:transit_flow/data/models/crew_list_model.dart';
import 'package:transit_flow/data/services/crew_services.dart';

class AddCrewDialog extends StatefulWidget {
  final Function(CrewMember) onCrewAdded;

  const AddCrewDialog({Key? key, required this.onCrewAdded}) : super(key: key);

  @override
  _AddCrewDialogState createState() => _AddCrewDialogState();
}

class _AddCrewDialogState extends State<AddCrewDialog> {
  final TextEditingController _crewIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  void _addCrew() async {
    if (_crewIdController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _roleController.text.isNotEmpty &&
        _statusController.text.isNotEmpty) {
      CrewMember newCrew = CrewMember(
        crewId: _crewIdController.text,
        name: _nameController.text,
        role: _roleController.text,
        status: _statusController.text,
      );

      final crewService = CrewServices(); // Create an instance of CrewServices
      await crewService
          .addCrewMember(newCrew); // Use the instance to call addCrewMember
      widget.onCrewAdded(newCrew);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Crew Member'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _crewIdController,
            decoration: const InputDecoration(labelText: 'Crew ID'),
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _roleController,
            decoration: const InputDecoration(labelText: 'Role'),
          ),
          TextField(
            controller: _statusController,
            decoration: const InputDecoration(labelText: 'Status'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _addCrew,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
