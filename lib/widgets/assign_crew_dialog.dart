import 'package:flutter/material.dart';
import 'package:transit_flow/data/models/crew_list_model.dart';
import 'package:transit_flow/data/models/schedule_bus_model.dart';

class AssignCrewDialog extends StatefulWidget {
  final ScheduledBus bus;
  final List<CrewMember> crewList;
  final Function(bool, List<CrewMember>) onSave; // Updated parameter type

  const AssignCrewDialog({
    Key? key,
    required this.bus,
    required this.crewList,
    required this.onSave,
  }) : super(key: key);

  @override
  _AssignCrewDialogState createState() => _AssignCrewDialogState();
}

class _AssignCrewDialogState extends State<AssignCrewDialog> {
  List<CrewMember> selectedCrewMembers = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assign Crew to ${widget.bus.busNumber}'),
      content: Container(
        width: 300,
        constraints: BoxConstraints(maxHeight: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.crewList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(widget.crewList[index].name),
                    value: selectedCrewMembers.contains(widget.crewList[index]),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (!selectedCrewMembers
                              .contains(widget.crewList[index])) {
                            selectedCrewMembers.add(widget.crewList[index]);
                          }
                        } else {
                          selectedCrewMembers.remove(widget.crewList[index]);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Pass isCrewAssigned as true and selected members to onSave callback
            widget.onSave(true, selectedCrewMembers);
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Assign'), // Changed to Assign
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
