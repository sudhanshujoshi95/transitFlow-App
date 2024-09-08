import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(),
      body: const Center(
        child: Text(
          'Reports Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
