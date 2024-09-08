import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/schedules_screen.dart';
import 'screens/crew_management_screen.dart';
import 'screens/reports_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TransitFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define routes for navigation
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardScreen(),
        '/schedules': (context) => ScheduleScreen(),
        '/crew-management': (context) => CrewManagementScreen(),
        '/reports': (context) => ReportsScreen(),
      },
    );
  }
}
