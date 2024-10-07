import 'package:flutter/material.dart';
import 'package:transit_flow/data/models/crew_list_model.dart';
import 'package:transit_flow/data/services/crew_services.dart';

// CrewMemberTile remains the same
class CrewMemberTile extends StatelessWidget {
  final String name;
  final String status;

  const CrewMemberTile({Key? key, required this.name, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'available':
        statusColor = Colors.green;
        break;
      case 'occupied':
        statusColor = const Color.fromARGB(255, 229, 203, 37);
        break;
      case 'on leave':
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

// CrewList to fetch and display from Firestore
class CrewList extends StatelessWidget {
  const CrewList({Key? key}) : super(key: key);

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
          // Use FutureBuilder to fetch crew members
          Expanded(
            child: FutureBuilder<List<CrewMember>>(
              future: CrewServices
                  .fetchCrewMembers(), // Fetch crew members from Firestore
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error loading crew members'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No crew members found'));
                }

                // If data is available, show the crew members
                List<CrewMember> crewMembers = snapshot.data!;
                return ListView.builder(
                  itemCount: crewMembers.length,
                  itemBuilder: (context, index) {
                    return CrewMemberTile(
                      name: crewMembers[index].name,
                      status: crewMembers[index].status,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
