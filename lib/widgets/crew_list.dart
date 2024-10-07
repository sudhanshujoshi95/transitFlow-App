import 'package:flutter/material.dart';

class CrewMemberTile extends StatelessWidget {
  final String name;
  final String status;

  const CrewMemberTile({Key? key, required this.name, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Available':
        statusColor = Colors.green;
        break;
      case 'Occupied':
        statusColor = Colors.orange;
        break;
      case 'On Leave':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(status),
      trailing: CircleAvatar(
        backgroundColor: statusColor,
        radius: 6,
      ),
    );
  }
}

class CrewList extends StatelessWidget {
  final List<Map<String, String>> crewMembers;

  const CrewList({Key? key, required this.crewMembers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Fixed width for crew list section
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crew List',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: crewMembers.map((crewMember) {
                return CrewMemberTile(
                  name: crewMember['name'] ?? '',
                  status: crewMember['status'] ?? '',
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
