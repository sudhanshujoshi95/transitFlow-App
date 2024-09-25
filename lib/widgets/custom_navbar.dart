import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        children: [
          Icon(Icons.bus_alert,
              color: Colors.blue, size: 25), // Adjust icon size as needed
          SizedBox(width: 10), // Space between icon and text
          Text(
            'TransitFlow',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 217, 230, 240),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: const Text(
              'Dashboard',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/schedules');
            },
            child: const Text(
              'Schedules',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/crew-management');
            },
            child: const Text(
              'Crew Management',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/busList');
            },
            child: const Text(
              'Bus List',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
