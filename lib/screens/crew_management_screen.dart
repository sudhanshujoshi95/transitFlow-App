import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';

class CrewManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(),
      body: const Center(
        child: Text(
          'Crew Management Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
